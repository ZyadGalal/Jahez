//
//  XCTestCase+Extension.swift
//  JahezMovies
//
//  Created by Zyad Galal on 09/05/2026.
//

import Foundation
import XCTest
import Combine

@MainActor
public extension XCTestCase {

    /// Awaits a publisher's first output (or completion) while running a side
    /// effect closure. Uses async `fulfillment` so concurrent `Task { … }`
    /// bodies on the main actor can make progress.
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 5.0,
        file: StaticString = #filePath,
        line: UInt = #line,
        when closure: () -> Void
    ) async throws -> T.Output {
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    result = .failure(error)
                }
                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )

        closure()

        await fulfillment(of: [expectation], timeout: timeout)
        cancellable.cancel()

        let unwrapped = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )
        return try unwrapped.get()
    }
}
