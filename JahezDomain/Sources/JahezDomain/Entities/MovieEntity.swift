//
//  MovieEntity.swift
//  JahezDomain
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public struct MovieEntity: Codable, Hashable, Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let releaseDate: String?
    public let genreIDs: [Int]
    public let overview: String
    public let voteAverage: Double

    public init(
        id: Int,
        title: String,
        posterPath: String?,
        releaseDate: String?,
        genreIDs: [Int],
        overview: String,
        voteAverage: Double
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genreIDs = genreIDs
        self.overview = overview
        self.voteAverage = voteAverage
    }
}
