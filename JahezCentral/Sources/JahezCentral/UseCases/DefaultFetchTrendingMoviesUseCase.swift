//
//  DefaultFetchTrendingMoviesUseCase.swift
//  JahezCentral
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import JahezDomain

public struct DefaultFetchTrendingMoviesUseCase: FetchTrendingMoviesUseCase {
    private let repository: MoviesRepository

    public init(repository: MoviesRepository) {
        self.repository = repository
    }

    public func execute(page: Int) async throws -> MoviesPageEntity {
        try await repository.trendingMovies(page: max(1, page))
    }
}
