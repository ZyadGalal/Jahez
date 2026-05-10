//
//  MockKeyValueStorage.swift
//  JahezCentralTests
//

import Foundation
import JahezData

final class MockKeyValueStorage: KeyValueStorage {

    private var storage: [String: Data] = [:]
    private let lock = NSLock()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func read<Value: Decodable>(_ type: Value.Type, forKey key: String) -> Value? {
        lock.lock(); defer { lock.unlock() }
        guard let data = storage[key] else { return nil }
        return try? decoder.decode(Value.self, from: data)
    }

    func write<Value: Encodable>(_ value: Value, forKey key: String) {
        guard let data = try? encoder.encode(value) else { return }
        lock.lock(); defer { lock.unlock() }
        storage[key] = data
    }

    func remove(forKey key: String) {
        lock.lock(); defer { lock.unlock() }
        storage.removeValue(forKey: key)
    }
}
