    //
//  MoviesDetailsModelTests.swift
//  JahezMoviesTests
//

import XCTest
import JahezDomain
@testable import JahezMovies

@MainActor
final class MoviesDetailsModelTests: XCTestCase {

    var viewModel: MovieDetailsViewModel!
    
    override func setUp() async throws {
        viewModel = MovieDetailsViewModel(movieID: 1,
                                          useCase: MockFetchMovieDetailsUseCase(result: .success(getMovieDetails())))
    }

    func testLoadSuccessfully() async throws {
        // Given
        // Drop the initial `.idle`, then wait for `.loading` followed by `.loaded`.
        let publisher = viewModel.$state
            .dropFirst()
            .collect(2)
            .first()

        // When
        _ = try await awaitPublisher(publisher) {
            viewModel.load()
        }

        // Then
        XCTAssertNotNil(viewModel.details)
    }

    func testLoadFail() async throws {
        // Given
        let error = DomainError.general(message: "errorMessage")
        let mockUseCase = MockFetchMovieDetailsUseCase(result: .failure(error))
        viewModel = MovieDetailsViewModel(movieID: 100,
                                          useCase: mockUseCase)
        let publisher = viewModel.$state
            .dropFirst()
            .collect(2)
            .first()
        
        // When
        let states = try await awaitPublisher(publisher) {
            viewModel.load()
        }
        
        // Then
        let unwrappedStates = try XCTUnwrap(states)
        XCTAssertEqual(error.errorDescription, unwrappedStates.last?.errorMessage)
    }
}

private extension MoviesDetailsModelTests {
    func getMovieDetails() -> MovieDetailsEntity {
        MovieDetailsEntity(id: 1,
                           title: "test",
                           posterPath: nil,
                           releaseDate: nil,
                           genres: [],
                           overview: "test",
                           homepage: nil,
                           budget: 100,
                           revenue: 1000,
                           spokenLanguages: nil,
                           status: "Released",
                           runtime: nil)
    }
}
