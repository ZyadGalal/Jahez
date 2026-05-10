//
//  NetworkMonitor.swift
//  JahezData
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import Combine
import Network
import JahezDomain

public final class NetworkMonitor: NetworkMonitoring, @unchecked Sendable {

    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.jaheztask.networkmonitor")
    private let subject: CurrentValueSubject<Bool, Never>
    private var hasStarted = false
    private let lock = NSLock()

    public init() {
        self.monitor = NWPathMonitor()
        self.subject = CurrentValueSubject(true)
    }

    public var isOnline: Bool { subject.value }

    public var isOnlinePublisher: AnyPublisher<Bool, Never> {
        subject
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func start() {
        lock.lock()
        defer { lock.unlock() }
        guard !hasStarted else { return }
        hasStarted = true
        monitor.pathUpdateHandler = { [weak self] path in
            let online = path.status == .satisfied
            DispatchQueue.main.async {
                self?.subject.send(online)
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
