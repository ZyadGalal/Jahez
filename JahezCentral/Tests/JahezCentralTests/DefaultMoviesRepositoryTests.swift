//
//  DefaultMoviesRepositoryTests.swift
//  JahezCentralTests
//

import XCTest
import JahezData
import JahezDomain
@testable import JahezCentral

final class DefaultMoviesRepositoryTests: XCTestCase {

    private let baseURL = URL(string: "https://api.themoviedb.org/3/")!
    var repo: DefaultMoviesRepository!
    
    func testGetMoviesResponse() async throws {
        // Given
        let client = MockAPIClient(result: .success(getMovies()))
        repo = DefaultMoviesRepository(
            apiClient: client,
            storage: MockKeyValueStorage()
        )
        
        // When
        let response = try await repo.trendingMovies(page: 1)
        
        // Then
        XCTAssertEqual(response.movies.count, getMovies().results?.count)
        
        
    }

    func testGetMoviesFailure() async {
        // Given
        let client = MockAPIClient(error: APIError.invalidURL)
        repo = DefaultMoviesRepository(
            apiClient: client,
            storage: MockKeyValueStorage()
        )

        // When / Then
        do {
            _ = try await repo.trendingMovies(page: 1)
            XCTFail("expected to throw")
        } catch let error as DomainError {
            guard case .general = error else {
                XCTFail("expected DomainError.general, got \(error)")
                return
            }
        } catch {
            XCTFail("unexpected error type: \(error)")
        }
    }

    func testGettingMoviesFromStorage () async throws {
        // Given
        let storage = MockKeyValueStorage()
        let client = MockAPIClient(result: .success(getMovies()))
        repo = DefaultMoviesRepository(apiClient: client, storage: storage)

        // When
        _ = try await repo.trendingMovies(page: 1)

        // Then
        let cached = storage.read(MoviesPageEntity.self, forKey: cacheKey(forPage: 1))
        XCTAssertEqual(cached?.page, 1)
        XCTAssertEqual(cached?.movies.count, 1)
        XCTAssertEqual(cached?.movies.first?.id, 1)
    }

    func testGetMoviesFromCacheIncaseAPIFails() async throws {
        // Given
        let storage = MockKeyValueStorage()
        let cached = makeEntity(page: 1, movieID: 99, title: "Cached")
        storage.write(cached, forKey: cacheKey(forPage: 1))
        let client = MockAPIClient(error: APIError.offline)
        repo = DefaultMoviesRepository(apiClient: client, storage: storage)

        // When
        let response = try await repo.trendingMovies(page: 1)

        // Then
        XCTAssertEqual(response, cached)
    }
}

private extension DefaultMoviesRepositoryTests {
    func getMovies() -> MoviesPageDTO {
        let movie = MovieDTO(
            id: 1,
            title: "test",
            originalTitle: "test title",
            posterPath: nil,
            releaseDate: nil,
            genreIds: nil,
            overview: nil,
            voteAverage: nil)

        return MoviesPageDTO(
            page: 1,
            totalPages: 1,
            totalResults: 1,
            results: [movie]
        )
    }

    /// Mirrors the private `pageKey(_:)` in `DefaultMoviesRepository`.
    /// Tests are deliberately coupled to this format because we're
    /// asserting the repository's caching contract.
    func cacheKey(forPage page: Int) -> String {
        "movies_page_\(page)"
    }

    func makeEntity(page: Int, movieID: Int, title: String) -> MoviesPageEntity {
        MoviesPageEntity(
            page: page,
            totalPages: 5,
            totalResults: 50,
            movies: [
                MovieEntity(
                    id: movieID,
                    title: title,
                    posterPath: nil,
                    releaseDate: nil,
                    genreIDs: [],
                    overview: "",
                    voteAverage: 0
                )
            ]
        )
    }
}
