//
//  DefaultFetchMovieDetailsUseCase.swift
//  JahezCentral
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import JahezDomain

public struct DefaultFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {
    private let repository: MoviesRepository

    public init(repository: MoviesRepository) {
        self.repository = repository
    }

    public func execute(movieID: Int) async throws -> MovieDetailsEntity {
        try await repository.movieDetails(id: movieID)
    }
}
