//
//  MovieDTO.swift
//  JahezData
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public struct MovieDTO: Decodable {
    public let id: Int?
    public let title: String?
    public let originalTitle: String?
    public let posterPath: String?
    public let releaseDate: String?
    public let genreIds: [Int]?
    public let overview: String?
    public let voteAverage: Double?
    
    public init(
        id: Int?,
        title: String?,
        originalTitle: String?,
        posterPath: String?,
        releaseDate: String?,
        genreIds: [Int]?,
        overview: String?,
        voteAverage: Double?
    ) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genreIds = genreIds
        self.overview = overview
        self.voteAverage = voteAverage
    }
}
