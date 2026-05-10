//
//  GenresRepository.swift
//  JahezDomain
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public protocol GenresRepository: Sendable {
    func genres() async throws -> [GenreEntity]
}
