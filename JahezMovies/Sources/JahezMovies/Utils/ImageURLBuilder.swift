//
//  ImageURLBuilder.swift
//  JahezMovies
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public protocol ImageURLBuilding: Sendable {
    func posterURL(for path: String?) -> URL?
    func largePosterURL(for path: String?) -> URL?
}

public struct ImageURLBuilder: ImageURLBuilding {

    private let baseURL: URL
    private let posterSize: String
    private let largePosterSize: String

    public init(
        baseURL: URL = URL(string: "https://image.tmdb.org/t/p/")!,
        posterSize: String = "w342",
        largePosterSize: String = "w500"
    ) {
        self.baseURL = baseURL
        self.posterSize = posterSize
        self.largePosterSize = largePosterSize
    }

    public func posterURL(for path: String?) -> URL? {
        url(for: path, size: posterSize)
    }

    public func largePosterURL(for path: String?) -> URL? {
        url(for: path, size: largePosterSize)
    }

    private func url(for path: String?, size: String) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        let trimmed = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return baseURL
            .appendingPathComponent(size, isDirectory: true)
            .appendingPathComponent(trimmed)
    }
}
