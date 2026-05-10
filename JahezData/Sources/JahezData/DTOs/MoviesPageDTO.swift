//
//  MoviesPageDTO.swift
//  JahezData
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public struct MoviesPageDTO: Decodable {
    public let page: Int?
    public let totalPages: Int?
    public let totalResults: Int?
    public let results: [MovieDTO]?

    public init(
        page: Int?,
        totalPages: Int?,
        totalResults: Int?,
        results: [MovieDTO]?
    ) {
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.results = results
    }
}
