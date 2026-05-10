//
//  MoviesRepository.swift
//  JahezDomain
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public protocol MoviesRepository: Sendable {
    func trendingMovies(page: Int) async throws -> MoviesPageEntity
    func movieDetails(id: Int) async throws -> MovieDetailsEntity
}
