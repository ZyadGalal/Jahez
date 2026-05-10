//
//  MockErrors.swift
//  JahezMovies
//
//  Created by Zyad Galal on 10/05/2026.
//

import Foundation

enum MockErrors: Error, LocalizedError {
    case general(message: String)
    
    var errorDescription: String {
        switch self {
        case .general(let message):
            return message
        }
    }
}
