//
//  MockUseCases.swift
//  JahezMoviesTests
//

import Foundation
import JahezDomain

final class MockFetchTrendingMoviesUseCase: FetchTrendingMoviesUseCase, @unchecked Sendable {

    private let result: Result<MoviesPageEntity, Error>

    init(result: Result<MoviesPageEntity, Error>) {
        self.result = result
    }

    func execute(page: Int) async throws -> MoviesPageEntity {
        return try result.get()
    }
}

final class MockFetchGenresUseCase: FetchGenresUseCase, @unchecked Sendable {

    private let result: Result<[GenreEntity], Error>

    init(result: Result<[GenreEntity], Error>) {
        self.result = result
    }

    func execute() async throws -> [GenreEntity] {
        return try result.get()
    }
}

final class MockFetchMovieDetailsUseCase: FetchMovieDetailsUseCase, @unchecked Sendable {
    private let result: Result<MovieDetailsEntity, Error>

    init(result: Result<MovieDetailsEntity, Error>) {
        self.result = result
    }

    func execute(movieID: Int) async throws -> MovieDetailsEntity {
        return try result.get()
    }
}
