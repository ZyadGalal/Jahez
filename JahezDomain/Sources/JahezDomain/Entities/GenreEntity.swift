//
//  Genre.swift
//  JahezDomain
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public struct GenreEntity: Codable, Hashable, Identifiable, Sendable {
    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
