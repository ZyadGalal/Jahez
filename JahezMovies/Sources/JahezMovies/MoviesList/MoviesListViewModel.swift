//
//  MoviesListViewModel.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import Combine
import SwiftUI
import JahezDomain

@MainActor
public final class MoviesListViewModel: MoviesListViewModelType {
    
    @Published private(set) public var movies: [MovieEntity] = []
    @Published private(set) public var filteredMovies: [MovieEntity] = []
    @Published private(set) public var genres: [GenreEntity] = []
    @Published private(set) public var state: ViewState = .idle
    @Published private(set) public var isLoadingNextPage: Bool = false
    @Published private(set) public var isOffline: Bool = false
    @Published public var selectedGenreIDs: Set<Int> = []
    @Published public var searchText: String = ""
    
    private let fetchMovies: FetchTrendingMoviesUseCase
    private let fetchGenres: FetchGenresUseCase
    private let networkMonitor: NetworkMonitoring
    
    private var currentPage: Int = 0
    private var totalPages: Int = 1
    private var cancellables = Set<AnyCancellable>()
    
    public var canLoadMore: Bool { currentPage < totalPages && !isLoadingNextPage }
    
    public init(
        fetchMovies: FetchTrendingMoviesUseCase,
        fetchGenres: FetchGenresUseCase,
        networkMonitor: NetworkMonitoring
    ) {
        self.fetchMovies = fetchMovies
        self.fetchGenres = fetchGenres
        self.networkMonitor = networkMonitor
        
        bindFiltering()
        bindNetworkState()
    }
    
    public func onAppear() {
        state = .loading
        refresh()
        loadGenres()
    }
    
    public func refresh() {
        currentPage = 0
        totalPages = 1
        movies = []
        loadNextPage()
    }
    
    public func loadNextPageIfNeeded(currentItemId id: Int) {
        let thresholdIndex = max(0, movies.count - 5)
        guard let index = movies.firstIndex(where: { $0.id == id}),
              index >= thresholdIndex else { return }
        loadNextPage()
    }
    
    public func toggleGenre(_ genre: GenreEntity) {
        if selectedGenreIDs.contains(genre.id) {
            selectedGenreIDs.remove(genre.id)
        } else {
            selectedGenreIDs.insert(genre.id)
        }
    }
    
    public func clearGenreFilters() {
        selectedGenreIDs.removeAll()
    }
}

//MARK: - bind and applying filters to the list
private extension MoviesListViewModel {
    func bindFiltering() {
        Publishers.CombineLatest3($movies, $searchText, $selectedGenreIDs)
            .map { movies, query, selectedGenres in
                self.applyFilters(to: movies, query: query, selectedGenres: selectedGenres)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$filteredMovies)
    }
    
    func applyFilters(to movies: [MovieEntity], query: String, selectedGenres: Set<Int>) -> [MovieEntity] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return movies.filter { movie in
            let matchesQuery = trimmed.isEmpty || movie.title.lowercased().contains(trimmed)
            let matchesGenre = selectedGenres.isEmpty || !selectedGenres.isDisjoint(with: movie.genreIDs)
            return matchesQuery && matchesGenre
        }
    }
}

// MARK: - Loading movies list and genres
private extension MoviesListViewModel {
    func loadNextPage() {
        guard canLoadMore else { return }
        let nextPage = currentPage + 1
        isLoadingNextPage = true

        Task { [weak self] in
            guard let self else { return }
            do {
                let page = try await self.fetchMovies.execute(page: nextPage)
                self.isLoadingNextPage = false
                self.append(page: page)
            } catch {
                self.isLoadingNextPage = false
                if self.movies.isEmpty {
                    self.state = .failed(message: error.localizedDescription)
                }
            }
        }
    }
    
    func append(page: MoviesPageEntity) {
        currentPage = page.page
        totalPages = page.totalPages
        movies.append(contentsOf: page.movies)
        if movies.isEmpty {
            state = .empty
        } else {
            state = .loaded
        }
    }
    
    func loadGenres() {
        Task { [weak self, fetchGenres] in
            guard let self else { return }
            do {
                self.genres = try await fetchGenres.execute()
            } catch {
                // Genres failure is non-fatal: list still shows movies without filters.
            }
        }
    }
}

// MARK: - Network status binding
private extension MoviesListViewModel {
    func bindNetworkState() {
        networkMonitor.isOnlinePublisher
            .sink { [weak self] isOnline in
                guard let self else { return }
                let wasOffline = self.isOffline
                self.isOffline = !isOnline
                if wasOffline && isOnline && self.movies.isEmpty {
                    self.refresh()
                }
            }
            .store(in: &cancellables)

        networkMonitor.start()
    }
}

