//
//  MockNetworkMonitoring.swift
//  JahezMovies
//
//  Created by Zyad Galal on 09/05/2026.
//

import Combine
import JahezDomain

final class MockNetworkMonitoring: NetworkMonitoring, @unchecked Sendable {
    private let subject: CurrentValueSubject<Bool, Never>

    init(initiallyOnline: Bool = true) {
        subject = CurrentValueSubject(initiallyOnline)
    }
    var isOnline: Bool { subject.value }
    var isOnlinePublisher: AnyPublisher<Bool, Never> {
        subject.eraseToAnyPublisher()
    }
    func start() {
    }
    /// Test hook: simulate a connectivity change.
    func send(isOnline: Bool) {
        subject.send(isOnline)
    }
}
