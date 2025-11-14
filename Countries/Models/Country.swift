//
//  Country.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import Foundation

struct Country: Identifiable, Equatable, Codable {
    struct Name: Codable, Equatable {
        let common: String
        let official: String?
    }

    struct Flag: Codable, Equatable {
        let png: URL?
        let svg: URL?

        private enum CodingKeys: String, CodingKey {
            case png
            case svg
        }
    }

    private enum CodingKeys: String, CodingKey {
        case cca2
        case cca3
        case ccn3
        case name
        case capital
        case region
        case subregion
        case population
        case area
        case flags
        case latlng
        case languages
        case timezones
        case continents
    }

    let cca2: String?
    let cca3: String?
    let ccn3: String?
    let name: Name
    let capital: [String]?
    let region: String?
    let subregion: String?
    let population: Int?
    let area: Double?
    let flags: Flag?
    let latlng: [Double]?
    let languages: [String: String]?
    let timezones: [String]?
    let continents: [String]?

    var id: String {
        cca3 ?? cca2 ?? ccn3 ?? UUID().uuidString
    }

    var displayName: String {
        name.common
    }

    var displayCapital: String {
        capital?.first ?? "No Capital"
    }

    var displayRegion: String {
        region ?? "Unknown Region"
    }

    var displayPopulation: String {
        guard let population else { return "Population data unavailable" }
        return NumberFormatter.localizedString(from: NSNumber(value: population), number: .decimal)
    }

    var displayArea: String {
        guard let area else { return "Area data unavailable" }
        return NumberFormatter.localizedString(from: NSNumber(value: area), number: .decimal) + " km²"
    }

    var flagURL: URL? {
        flags?.png ?? flags?.svg
    }
}

