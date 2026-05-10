//
//  MoviesListView.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import SwiftUI
import JahezDomain

@MainActor
public struct MoviesListView<ViewModel: MoviesListViewModelType>: View {

    @StateObject private var viewModel: ViewModel
    @State private var presentedMovieID: Int?
    private let router: MoviesRouting
    private let imageURLBuilder: ImageURLBuilding

    public init(
        viewModel: ViewModel,
        router: MoviesRouting,
        imageURLBuilder: ImageURLBuilding
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.router = router
        self.imageURLBuilder = imageURLBuilder
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isOffline {
                    offlineBanner
                }
                if !viewModel.genres.isEmpty {
                    GenreChipsView(
                        genres: viewModel.genres,
                        selectedGenreIDs: viewModel.binding(\.selectedGenreIDs),
                        onClear: { viewModel.clearGenreFilters() }
                    )
                    .background(.bar)
                }
                content
            }
            .navigationTitle("Trending")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: viewModel.binding(\.searchText), prompt: "Search movies")
            .refreshable {
                await MainActor.run {
                    viewModel.refresh()
                }
            }
            .task {
                await MainActor.run {
                    viewModel.onAppear()
                }
            }
            .navigationDestination(item: $presentedMovieID) { id in
                router.movieDetailsView(id: id)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading movies…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            ErrorStateView(message: message, retry: { viewModel.refresh() })
        case .empty, .loaded:
            list
        }
    }

    private var list: some View {
        Group {
            if viewModel.filteredMovies.isEmpty {
                emptyResults
            } else {
                List {
                    ForEach(viewModel.filteredMovies) { movie in
                        Button {
                            presentedMovieID = movie.id
                        } label: {
                            MovieRowView(movie: movie, imageURLBuilder: imageURLBuilder)
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            viewModel.loadNextPageIfNeeded(currentItemId: movie.id)
                        }
                    }
                    if viewModel.isLoadingNextPage {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    private var emptyResults: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
            Text("No movies match your filters")
                .font(.headline)
            Text(emptyMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyMessage: String {
        if !viewModel.selectedGenreIDs.isEmpty {
            return "Try clearing some genre filters or scrolling to load more pages."
        }
        if !viewModel.searchText.isEmpty {
            return "Try a different search term."
        }
        return "Pull to refresh."
    }

    private var offlineBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
            Text("Offline — showing cached results")
                .font(.footnote.weight(.semibold))
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.orange)
    }

}
