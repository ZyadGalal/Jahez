//
//  DefaultGenresRepositoryTests.swift
//  JahezCentralTests
//

import XCTest
import JahezData
import JahezDomain
@testable import JahezCentral

final class DefaultGenresRepositoryTests: XCTestCase {

    private let baseURL = URL(string: "https://api.themoviedb.org/3/")!
    var repo: DefaultGenresRepository!

    func testGetGenresResponse() async throws {
        // Given
        let client = MockAPIClient(result: .success(getGenresDTO()))
        repo = DefaultGenresRepository(
            apiClient: client,
            storage: MockKeyValueStorage()
        )

        // When
        let response = try await repo.genres()

        // Then
        XCTAssertEqual(response.count, getGenresDTO().genres?.count)
        XCTAssertEqual(response.first?.name, "Action")
    }

    func testGetGenresFailure() async {
        // Given
        let client = MockAPIClient(error: APIError.invalidURL)
        repo = DefaultGenresRepository(
            apiClient: client,
            storage: MockKeyValueStorage()
        )

        // When / Then
        do {
            _ = try await repo.genres()
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

    // MARK: - Storage interaction

    func testGetGenresWritesToCacheSuccessfully() async throws {
        // Given
        let storage = MockKeyValueStorage()
        let client = MockAPIClient(result: .success(getGenresDTO()))
        repo = DefaultGenresRepository(apiClient: client, storage: storage)

        // When
        _ = try await repo.genres()

        // Then
        let cached = storage.read([GenreEntity].self, forKey: cacheKey)
        XCTAssertEqual(cached?.count, 2)
        XCTAssertEqual(cached?.first?.name, "Action")
    }

    func testGetGenresFromCacheIncaseAPIFails() async throws {
        // Given
        let storage = MockKeyValueStorage()
        let cached: [GenreEntity] = [
            GenreEntity(id: 99, name: "Cached"),
            GenreEntity(id: 100, name: "FromDisk")
        ]
        storage.write(cached, forKey: cacheKey)
        let client = MockAPIClient(error: APIError.offline)
        repo = DefaultGenresRepository(apiClient: client, storage: storage)

        // When
        let response = try await repo.genres()

        // Then
        XCTAssertEqual(response, cached)
    }
}

private extension DefaultGenresRepositoryTests {
    var cacheKey: String { "genres_list" }

    func getGenresDTO() -> GenreListDTO {
        GenreListDTO(
            genres: [
                GenreDTO(id: 1, name: "Action"),
                GenreDTO(id: 2, name: "Comedy")
            ]
        )
    }
}
