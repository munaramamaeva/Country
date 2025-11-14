//
//  CountryDetailsViewModel.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import Foundation

struct CountryDetailsViewModel: Identifiable, Equatable {
    private let country: Country

    init(country: Country) {
        self.country = country
    }

    var id: String { country.id }

    var title: String { country.displayName }

    var subtitle: String {
        [country.displayCapital, country.displayRegion].joined(separator: " · ")
    }

    var flagURL: URL? {
        country.flagURL
    }

    var officialName: String {
        country.name.official ?? country.displayName
    }

    var populationText: String { country.displayPopulation }

    var areaText: String { country.displayArea }

    var region: String { country.displayRegion }

    var subregion: String { country.subregion ?? "Subregion unavailable" }

    var coordinates: String {
        guard let latlng = country.latlng, latlng.count == 2 else {
            return "Coordinates unavailable"
        }
        return String(format: "%.2f°, %.2f°", latlng[0], latlng[1])
    }

    var languages: String {
        guard let languages = country.languages else {
            return "Languages unavailable"
        }
        return languages.values.sorted().joined(separator: ", ")
    }

    var timezones: String {
        guard let timezones = country.timezones else {
            return "Timezones unavailable"
        }
        return timezones.joined(separator: ", ")
    }

    var continents: String {
        guard let continents = country.continents else {
            return "Continents unavailable"
        }
        return continents.joined(separator: ", ")
    }
}

