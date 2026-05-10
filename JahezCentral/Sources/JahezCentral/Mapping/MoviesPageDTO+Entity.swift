//
//  MoviesPageDTO+Entity.swift
//  JahezCentral
//
//  Created by Zyad Galal on 09/05/2026.
//

import Foundation
import JahezData
import JahezDomain

extension MovieDTO {
    public func toEntity() -> MovieEntity {
        MovieEntity(
            id: id ?? 0,
            title: title ?? originalTitle ?? "Untitled",
            posterPath: posterPath,
            releaseDate: releaseDate,
            genreIDs: genreIds ?? [],
            overview: overview ?? "",
            voteAverage: voteAverage ?? 0
        )
    }
}

extension MoviesPageDTO {
    public func toEntity() -> MoviesPageEntity {
        MoviesPageEntity(
            page: page ?? 0,
            totalPages: totalPages ?? 0,
            totalResults: totalResults ?? 0,
            movies: results?.map { $0.toEntity() } ?? []
        )
    }
}
