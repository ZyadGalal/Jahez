//
//  APIClient.swift
//  JahezData
//
//  Created by Zyad Galal on 07/05/2026.
//

import Foundation

public protocol APIClientProtocol {
    func send<Response: Decodable>(
        _ type: Response.Type,
        _ endpoint: Endpoint
    ) async throws -> Response
}

public struct APICredentials {
    public let apiKey: String
    public let bearerToken: String

    public init(apiKey: String, bearerToken: String) {
        self.apiKey = apiKey
        self.bearerToken = bearerToken
    }

    public var hasCredentials: Bool { !apiKey.isEmpty || !bearerToken.isEmpty }
}

public final class APIClient: APIClientProtocol {

    private let session: URLSession
    private let baseURL: URL
    private let credentials: APICredentials
    private let timeout: TimeInterval = 30

    public init(
        session: URLSession = URLSession(configuration: .default),
        baseURL: URL,
        credentials: APICredentials
    ) {
        self.session = session
        self.baseURL = baseURL
        self.credentials = credentials
    }

    public func send<Response: Decodable>(
        _ type: Response.Type,
        _ endpoint: Endpoint
    ) async throws -> Response {
        guard credentials.hasCredentials else { throw APIError.missingAPIKey }

        let request = try makeRequest(for: endpoint)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let urlError as URLError {
            throw Self.mapURLError(urlError)
        } catch let apiError as APIError {
            throw apiError
        } catch {
            throw APIError.underlying(message: error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            throw APIError.requestFailed(statusCode: http.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw APIError.decodingFailed
        }
    }

    private func makeRequest(for endpoint: Endpoint) throws -> URLRequest {
        let resolvedURL = baseURL.appendingPathComponent(endpoint.path)
        guard var components = URLComponents(url: resolvedURL, resolvingAgainstBaseURL: false) else {
            throw APIError.invalidURL
        }
        var query = endpoint.queryItems
        query.append(URLQueryItem(name: "api_key", value: credentials.apiKey))
        components.queryItems = query
        guard let url = components.url else { throw APIError.invalidURL }

        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(credentials.bearerToken)", forHTTPHeaderField: "Authorization")
        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }

    private static func mapURLError(_ error: URLError) -> APIError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed, .cannotConnectToHost, .timedOut:
            return .offline
        default:
            return .underlying(message: error.localizedDescription)
        }
    }
}
