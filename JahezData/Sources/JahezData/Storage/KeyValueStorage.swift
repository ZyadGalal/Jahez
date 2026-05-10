//
//  KeyValueStorage.swift
//  JahezData
//
//  Created by Zyad Galal on 09/05/2026.
//

import Foundation

public protocol KeyValueStorage {
    func read<Value: Decodable>(
        _ type: Value.Type,
        forKey key: String
    ) async -> Value?
    func write<Value: Encodable>(
        _ value: Value,
        forKey key: String
    ) async
}
