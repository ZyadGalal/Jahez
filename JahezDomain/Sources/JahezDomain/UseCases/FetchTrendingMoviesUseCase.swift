//
//  FetchTrendingMoviesUseCase.swift
//  JahezDomain
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public protocol FetchTrendingMoviesUseCase: Sendable {
    func execute(page: Int) async throws -> MoviesPageEntity
}
