//
//  MockRepositories.swift
//  JahezMoviesTests
//

import Foundation
import JahezDomain

final class MockMoviesRepository: MoviesRepository {

    private let trendingMoviesResult: Result<MoviesPageEntity, Error>
    private let movieDetailsResult: Result<MovieDetailsEntity, Error>

    init(
        trendingMoviesResult: Result<MoviesPageEntity, Error> = .failure(DomainError.general(message: "not stubbed")),
        movieDetailsResult: Result<MovieDetailsEntity, Error> = .failure(DomainError.general(message: "not stubbed"))
    ) {
        self.trendingMoviesResult = trendingMoviesResult
        self.movieDetailsResult = movieDetailsResult
    }

    func trendingMovies(page: Int) async throws -> MoviesPageEntity {
        return try trendingMoviesResult.get()
    }

    func movieDetails(id: Int) async throws -> MovieDetailsEntity {
        return try movieDetailsResult.get()
    }
}

final class MockGenresRepository: GenresRepository, @unchecked Sendable {

    private let result: Result<[GenreEntity], Error>

    init(result: Result<[GenreEntity], Error> = .success([])) {
        self.result = result
    }

    func genres() async throws -> [GenreEntity] {
        return try result.get()
    }
}
