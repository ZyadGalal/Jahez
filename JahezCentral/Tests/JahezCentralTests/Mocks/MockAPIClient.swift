//
//  MockAPIClient.swift
//  JahezCentral
//
//  Created by Zyad Galal on 10/05/2026.
//

import Foundation
import JahezData

final class MockAPIClient: APIClientProtocol, @unchecked Sendable {

    private let result: Result<Any, Error>

    init<Value>(result: Result<Value, Error>) {
        self.result = result.map { $0 as Any }
    }

    /// Convenience for the failure case so callers don't need to spell out
    /// the success type in `Result<…, Error>.failure(…)`.
    init(error: Error) {
        self.result = .failure(error)
    }

    func send<Response: Decodable>(_ type: Response.Type, _ endpoint: Endpoint) async throws -> Response {
        let value = try result.get()
        guard let cast = value as? Response else {
            fatalError(
                "MockAPIClient stub of type is not assignable to \(Response.self)"
            )
        }
        return cast
    }
}
