@testable import Countries
import Foundation

enum MockError: Error, LocalizedError {
    case sample

    var errorDescription: String? {
        "sample error"
    }
}

final class CountriesServiceMock: CountriesServiceProtocol {
    private let result: Result<[Country], Error>

    init(result: Result<[Country], Error>) {
        self.result = result
    }

    func fetchCountries() async throws -> [Country] {
        switch result {
        case .success(let countries):
            return countries
        case .failure(let error):
            throw error
        }
    }
}

enum SampleData {
    static let countries: [Country] = [
        Country(
            cca2: "NO",
            cca3: "NOR",
            ccn3: "578",
            name: .init(common: "Norway", official: "Kingdom of Norway"),
            capital: ["Oslo"],
            region: "Europe",
            subregion: "Northern Europe",
            population: 5465629,
            area: 323802,
            flags: .init(png: URL(string: "https://flagcdn.com/w320/no.png"), svg: nil),
            latlng: [62.0, 10.0],
            languages: ["nor": "Norwegian"],
            timezones: ["UTC+01:00"],
            continents: ["Europe"]
        ),
        Country(
            cca2: "KE",
            cca3: "KEN",
            ccn3: "404",
            name: .init(common: "Kenya", official: "Republic of Kenya"),
            capital: ["Nairobi"],
            region: "Africa",
            subregion: "Eastern Africa",
            population: 53771300,
            area: 580367,
            flags: .init(png: URL(string: "https://flagcdn.com/w320/ke.png"), svg: nil),
            latlng: [-1.0, 38.0],
            languages: ["swa": "Swahili", "eng": "English"],
            timezones: ["UTC+03:00"],
            continents: ["Africa"]
        ),
        Country(
            cca2: "AU",
            cca3: "AUS",
            ccn3: "036",
            name: .init(common: "Australia", official: "Commonwealth of Australia"),
            capital: ["Canberra"],
            region: "Oceania",
            subregion: "Australia and New Zealand",
            population: 25687041,
            area: 7692024,
            flags: .init(png: URL(string: "https://flagcdn.com/w320/au.png"), svg: nil),
            latlng: [-27.0, 133.0],
            languages: ["eng": "English"],
            timezones: ["UTC+08:00"],
            continents: ["Oceania"]
        )
    ]

    static let largeCountriesList: [Country] = {
        var list: [Country] = []
        for index in 1...10 {
            let country = Country(
                cca2: "C\(index)",
                cca3: "CT\(index)",
                ccn3: "\(index)",
                name: .init(common: "Country \(index)", official: "Country \(index) Official"),
                capital: ["Capital \(index)"],
                region: index % 2 == 0 ? "Europe" : "Asia",
                subregion: nil,
                population: 1000 * index,
                area: Double(100 * index),
                flags: .init(png: nil, svg: nil),
                latlng: nil,
                languages: nil,
                timezones: nil,
                continents: nil
            )
            list.append(country)
        }
        return list
    }()
}

