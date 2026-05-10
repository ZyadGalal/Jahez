//
//  AppConfiguration.swift
//  JahezTask
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

struct AppConfiguration {
    private var properties: [String: String] = [:]

    public init() {
        for (key, value) in (Bundle.main.infoDictionary) ?? [:] {
            properties[key] = value as? String ?? ""
        }
    }
    
    public var baseURL: URL {
        return URL(string: properties["BASE_URL"] ?? "")!
    }

    public var apiKey: String {
        return properties["API_KEY"] ?? ""
    }

    public var bearerToken: String {
        properties["BEARER_TOKEN"] ?? ""
    }
}
