//
//  TMDBEndpoints.swift
//  JahezData
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public enum TMDBEndpoints {

    public static func discoverMovies(page: Int) -> Endpoint {
        Endpoint(
            path: "discover/movie",
            method: .get,
            queryItems: [
                URLQueryItem(name: "sort_by", value: "popularity.desc"),
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "page", value: String(page))
            ]
        )
    }

    public static func movieDetails(id: Int) -> Endpoint {
        Endpoint(
            path: "movie/\(id)",
            method: .get,
            queryItems: [URLQueryItem(name: "language", value: "en-US")]
        )
    }

    public static func genres() -> Endpoint {
        Endpoint(
            path: "genre/movie/list",
            method: .get,
            queryItems: [URLQueryItem(name: "language", value: "en-US")]
        )
    }
}
