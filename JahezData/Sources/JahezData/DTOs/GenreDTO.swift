//
//  GenreDTO.swift
//  JahezData
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public struct GenreDTO: Decodable {
    public let id: Int?
    public let name: String?

    public init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

public struct GenreListDTO: Decodable {
    public let genres: [GenreDTO]?

    public init(genres: [GenreDTO]?) {
        self.genres = genres
    }
}
