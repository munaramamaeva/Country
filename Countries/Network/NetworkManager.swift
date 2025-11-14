//
//  NetworkManager.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import Foundation

protocol NetworkExecuting {
    func execute<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T
}

struct NetworkManager: NetworkExecuting {
    enum NetworkError: Error, LocalizedError {
        case invalidURL
        case invalidResponse
        case decodingFailed(Error)
        case transportError(Error)

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The request URL is invalid."
            case .invalidResponse:
                return "The server response was invalid."
            case .decodingFailed(let error):
                return "Unable to decode data: \(error.localizedDescription)"
            case .transportError(let error):
                return "Network request failed: \(error.localizedDescription)"
            }
        }
    }

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func execute<T: Decodable>(_ request: URLRequest, as type: T.Type) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decodingFailed(error)
        } catch {
            throw NetworkError.transportError(error)
        }
    }
}
