//
//  MovieDetailsDTO.swift
//  JahezData
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public struct MovieDetailsDTO: Decodable {
    public let id: Int?
    public let title: String?
    public let originalTitle: String?
    public let posterPath: String?
    public let releaseDate: String?
    public let genres: [GenreDTO]?
    public let overview: String?
    public let homepage: String?
    public let budget: Int?
    public let revenue: Int?
    public let spokenLanguages: [SpokenLanguageDTO]?
    public let status: String?
    public let runtime: Int?
}
