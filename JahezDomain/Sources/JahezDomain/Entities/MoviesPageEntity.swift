//
//  MoviesPage.swift
//  JahezDomain
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public struct MoviesPageEntity: Codable, Hashable, Sendable {
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int
    public let movies: [MovieEntity]

    public init(page: Int, totalPages: Int, totalResults: Int, movies: [MovieEntity]) {
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.movies = movies
    }

    public var hasNextPage: Bool { page < totalPages }
}
