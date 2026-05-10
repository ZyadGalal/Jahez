//
//  DefaultGenresRepository.swift
//  JahezCentral
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import JahezData
import JahezDomain

public final class DefaultGenresRepository: GenresRepository, @unchecked Sendable {

    private static let genresKey = "genres_list"

    private let apiClient: APIClientProtocol
    private let storage: KeyValueStorage

    public init(apiClient: APIClientProtocol, storage: KeyValueStorage) {
        self.apiClient = apiClient
        self.storage = storage
    }

    public func genres() async throws -> [GenreEntity] {
        do {
            let dto = try await apiClient.send(GenreListDTO.self,TMDBEndpoints.genres())
            let entities = (dto.genres ?? []).map { $0.toEntity() }
            await storage.write(entities, forKey: Self.genresKey)
            return entities
        } catch let apiError as APIError {
            if let cached = await storage.read([GenreEntity].self, forKey: Self.genresKey), !cached.isEmpty {
                return cached
            }
            throw apiError
        }
    }
}
