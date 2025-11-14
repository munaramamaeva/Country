//
//  CountryTarget.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import Foundation

enum CountryTarget {
    case allCountries(fields: [Field])

    enum Field: String {
        case name
        case capital
        case region
        case population
        case area
        case flags
        case latlng
        case languages
        case timezones
        case cca3
    }
}

extension CountryTarget {
    private var baseURLString: String {
        "https://restcountries.com"
    }

    private var path: String {
        switch self {
        case .allCountries:
            return "/v3.1/all"
        }
    }

    private var method: String {
        "GET"
    }

    private var queryItems: [URLQueryItem]? {
        switch self {
        case .allCountries(let fields):
            guard !fields.isEmpty else { return nil }
            return [
                URLQueryItem(
                    name: "fields",
                    value: fields.map(\.rawValue).joined(separator: ",")
                )
            ]
        }
    }

    func makeRequest(timeout: TimeInterval = 30) throws -> URLRequest {
        let urlString = baseURLString + path

        guard var components = URLComponents(string: urlString) else {
            throw NetworkManager.NetworkError.invalidURL
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw NetworkManager.NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = timeout
        return request
    }
}

extension Array where Element == CountryTarget.Field {
    static var `default`: [CountryTarget.Field] {
        [
            .name,
            .capital,
            .region,
            .population,
            .area,
            .flags,
            .latlng,
            .languages,
            .timezones,
            .cca3
        ]
    }
}

