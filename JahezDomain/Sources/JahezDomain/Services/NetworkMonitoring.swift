//
//  NetworkMonitoring.swift
//  JahezDomain
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import Combine

public protocol NetworkMonitoring: Sendable {
    var isOnline: Bool { get }
    var isOnlinePublisher: AnyPublisher<Bool, Never> { get }
    func start()
}
