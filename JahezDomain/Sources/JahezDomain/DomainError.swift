//
//  DomainError.swift
//  JahezDomain
//

import Foundation

public enum DomainError: Error, LocalizedError, Equatable, Sendable {
    case offline
    case general(message: String)

    public var errorDescription: String? {
        switch self {
        case .offline:
            return nil
        case .general(let message):
            return message
        }
    }
}
