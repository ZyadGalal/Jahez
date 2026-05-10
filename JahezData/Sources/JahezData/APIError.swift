//
//  APIError.swift
//  JahezData
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public enum APIError: Error, LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
    case decodingFailed
    case offline
    case missingAPIKey
    case underlying(message: String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL could not be constructed."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .requestFailed(let code):
            return "The server responded with an error (status \(code))."
        case .decodingFailed:
            return "We couldn't read the response from the server."
        case .offline:
            return "You appear to be offline. Showing cached results when available."
        case .missingAPIKey:
            return "TMDB credentials are missing. Add them to Secrets.plist or the TMDB_API_KEY environment variable."
        case .underlying(let message):
            return message
        }
    }
}
