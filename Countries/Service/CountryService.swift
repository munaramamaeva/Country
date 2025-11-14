//
//  CountryService.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import Foundation

protocol CountriesServiceProtocol {
    func fetchCountries() async throws -> [Country]
}

final class CountriesService: CountriesServiceProtocol {
    private let networkExecutor: NetworkExecuting
    

    init(networkExecutor: NetworkExecuting = NetworkManager()) {
        self.networkExecutor = networkExecutor
    }

    func fetchCountries() async throws -> [Country] {
        let request = try CountryTarget.allCountries(fields: .default).makeRequest()
        return try await networkExecutor.execute(request, as: [Country].self)
    }
}

