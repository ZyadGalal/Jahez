//
//  MoviesListViewModelTests.swift
//  JahezMoviesTests
//

import XCTest
import JahezDomain
@testable import JahezMovies

@MainActor
final class MoviesListViewModelTests: XCTestCase {

    var viewModel: MoviesListViewModel!
    
    override func setUp() async throws {
        viewModel = MoviesListViewModel(
            fetchMovies: MockFetchTrendingMoviesUseCase(
                result: .success(getMoviesPageEntity())
            ),
            fetchGenres: MockFetchGenresUseCase(result: .success(getGenres())),
            networkMonitor: MockNetworkMonitoring()
        )
    }
    
    func testOnAppear() async throws {
        // Given
        let movies = getMovies()
        // Drop the initial `.idle`, then wait for `.loading` followed by `.loaded`.
        let publisher = viewModel.$state
            .dropFirst()
            .collect(2)
            .first()

        // When
        let states = try await awaitPublisher(publisher) {
            viewModel.onAppear()
        }

        // Then
        XCTAssertEqual(states, [.loading, .loaded])
        XCTAssertEqual(movies.count, viewModel.movies.count)
    }

    func testToggleGenre() async throws {
        // Given
        let firstGenre = getGenres().first
        let publisher = viewModel.$filteredMovies
            .dropFirst()
            .collect(3)
            .first()

        // When
        let _ = try await awaitPublisher(publisher) {
            viewModel.onAppear()
            viewModel.toggleGenre(firstGenre ?? GenreEntity(id: -1, name: "nil"))
        }

        // Then
        XCTAssertTrue(viewModel.selectedGenreIDs.contains(firstGenre?.id ?? -100))
        XCTAssertEqual(viewModel.filteredMovies.count, 1)
    }

    func testNotLoadingNewPage() async throws {
        // Given
        let movies = getMovies()
        let publisher = viewModel.$state
            .dropFirst()
            .collect(2)
            .first()

        _ = try await awaitPublisher(publisher) {
            viewModel.onAppear()
        }
        guard let lastItemId = movies.last?.id else { return }
        
        // When
        viewModel.loadNextPageIfNeeded(currentItemId: lastItemId)
        
        // Then
        XCTAssertEqual(movies.count, viewModel.movies.count)
    }

    func testResetGenre() async throws {
        // Given
        let movies = getMovies()
        let firstGenre = getGenres().first
        let publisher = viewModel.$filteredMovies
            .dropFirst()
            .collect(4)
            .first()

        // When
        let _ = try await awaitPublisher(publisher) {
            viewModel.onAppear()
            viewModel.toggleGenre(firstGenre ?? GenreEntity(id: -1, name: "nil"))
            viewModel.clearGenreFilters()
        }
                
        // Then
        XCTAssertEqual(movies.count, viewModel.filteredMovies.count)
    }
}

private extension MoviesListViewModelTests {
    func getMoviesPageEntity() -> MoviesPageEntity {
        return MoviesPageEntity(
            page: 1,
            totalPages: 10,
            totalResults: 100,
            movies: getMovies())
    }

    func getMovies() -> [MovieEntity] {
        return [
        MovieEntity(
            id: 1,
            title: "tesst",
            posterPath: nil,
            releaseDate: nil,
            genreIDs: [3,4],
            overview: "test test",
            voteAverage: 3.0
        ),
        MovieEntity(
            id: 2,
            title: "test 2",
            posterPath: nil,
            releaseDate: nil,
            genreIDs: [1,2],
            overview: "test test test test ",
            voteAverage: 4.0
        ),
        ]
    }

    func getGenres() -> [GenreEntity] {
        return [
            GenreEntity(id: 1, name: "test"),
            GenreEntity(id: 2, name: "test 2"),
            GenreEntity(id: 3, name: "test 3")
        ]
    }
}
