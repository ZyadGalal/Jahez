//
//  DefaultMoviesRepository.swift
//  JahezCentral
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import JahezData
import JahezDomain

public final class DefaultMoviesRepository: MoviesRepository, @unchecked Sendable {

    private let apiClient: APIClientProtocol
    private let storage: KeyValueStorage

    public init(apiClient: APIClientProtocol, storage: KeyValueStorage) {
        self.apiClient = apiClient
        self.storage = storage
    }

    public func trendingMovies(page: Int) async throws -> MoviesPageEntity {
        let key = Self.pageKey(page)
        do {
            let dto = try await apiClient.send(
                MoviesPageDTO.self,
                TMDBEndpoints.discoverMovies(page: page)
            )
            let entity = dto.toEntity()
            await storage.write(entity, forKey: key)
            return entity
        } catch let apiError as APIError {
            if let cached = await storage.read(
                MoviesPageEntity.self,
                forKey: key
            ) {
                return cached
            }
            throw apiError
        }
    }

    public func movieDetails(id: Int) async throws -> MovieDetailsEntity {
        let key = Self.detailsKey(id)
        do {
            let dto = try await apiClient.send(
                MovieDetailsDTO.self,
                TMDBEndpoints.movieDetails(id: id)
            )
            let entity = dto.toEntity()
            await storage.write(entity, forKey: key)
            return entity
        } catch let apiError as APIError {
            if let cached = await storage.read(
                MovieDetailsEntity.self,
                forKey: key
            ) {
                return cached
            }
            throw apiError
        }
    }

    private static func pageKey(_ page: Int) -> String { "movies_page_\(page)" }
    private static func detailsKey(_ id: Int) -> String { "movie_details_\(id)" }
}
