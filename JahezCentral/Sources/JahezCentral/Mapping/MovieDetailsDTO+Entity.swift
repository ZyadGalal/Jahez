//
//  MovieDetailsDTO+Entity.swift
//  JahezCentral
//
//  Created by Zyad Galal on 09/05/2026.
//

import Foundation
import JahezDomain
import JahezData

extension GenreDTO {
    public func toEntity() -> GenreEntity {
        GenreEntity(
            id: id ?? 0,
            name: name ?? ""
        )
    }
}

extension MovieDetailsDTO {
    public func toEntity() -> MovieDetailsEntity {
        let spokenLanguages = spokenLanguages?
            .compactMap {($0.englishName ?? "").isEmpty ? $0.name : $0.englishName}
            .joined(separator: ",")
        
        return MovieDetailsEntity(
            id: id ?? 0,
            title: title ?? originalTitle ?? "Untitled",
            posterPath: posterPath,
            releaseDate: releaseDate,
            genres: (genres ?? []).map { $0.toEntity() },
            overview: overview ?? "",
            homepage: homepage.flatMap(URL.init(string:)),
            budget: budget ?? 0,
            revenue: revenue ?? 0,
            spokenLanguages: spokenLanguages,
            status: status ?? "",
            runtime: runtime
        )
    }
}
