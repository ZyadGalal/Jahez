//
//  MoviesListViewModelType.swift
//  JahezMovies
//

import Foundation
import JahezDomain

@MainActor
public protocol MoviesListViewModelType: ObservableObject {
    // Outputs
    var movies: [MovieEntity] { get }
    var filteredMovies: [MovieEntity] { get }
    var genres: [GenreEntity] { get }
    var state: ViewState { get }
    var isLoadingNextPage: Bool { get }
    var isOffline: Bool { get }

    // Inputs
    var searchText: String { get set }
    var selectedGenreIDs: Set<Int> { get set }
    func onAppear()
    func refresh()
    func loadNextPageIfNeeded(currentItemId id: Int)
    func toggleGenre(_ genre: GenreEntity)
    func clearGenreFilters()
}
