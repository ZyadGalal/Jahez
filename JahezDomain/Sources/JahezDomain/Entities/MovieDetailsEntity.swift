//
//  MovieDetails.swift
//  JahezDomain
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public struct MovieDetailsEntity: Codable, Hashable, Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let posterPath: String?
    public let releaseDate: String?
    public let genres: [GenreEntity]
    public let overview: String
    public let homepage: URL?
    public let budget: Int
    public let revenue: Int
    public let spokenLanguages: String?
    public let status: String
    public let runtime: Int?

    public init(
        id: Int,
        title: String,
        posterPath: String?,
        releaseDate: String?,
        genres: [GenreEntity],
        overview: String,
        homepage: URL?,
        budget: Int,
        revenue: Int,
        spokenLanguages: String?,
        status: String,
        runtime: Int?
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genres = genres
        self.overview = overview
        self.homepage = homepage
        self.budget = budget
        self.revenue = revenue
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.runtime = runtime
    }
}
