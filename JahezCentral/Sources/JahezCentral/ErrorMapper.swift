//
//  ErrorMapper.swift
//  JahezCentral
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation
import JahezData
import JahezDomain

public enum ErrorMapper {
    public static func map(_ error: APIError) -> DomainError {
        let message = error.localizedDescription
        switch error {
        case .offline:
            return .offline
        default:
            return .general(message: message)
        }
    }
}
