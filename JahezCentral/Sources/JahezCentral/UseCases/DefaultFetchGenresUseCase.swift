//
//  DefaultFetchGenresUseCase.swift
//  JahezCentral
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import JahezDomain

public struct DefaultFetchGenresUseCase: FetchGenresUseCase {
    private let repository: GenresRepository

    public init(repository: GenresRepository) {
        self.repository = repository
    }

    public func execute() async throws -> [GenreEntity] {
        try await repository.genres()
    }
}
