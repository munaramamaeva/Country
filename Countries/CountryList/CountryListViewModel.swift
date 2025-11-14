//
//  CountryListViewModel.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import Foundation
import Combine

@MainActor
final class CountryListViewModel: ObservableObject {
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case empty(String)
        case failed(String)
    }

    enum RegionFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case africa = "Africa"
        case americas = "Americas"
        case asia = "Asia"
        case europe = "Europe"
        case oceania = "Oceania"
        case antarctic = "Antarctic"
        case polar = "Polar"

        var id: String { rawValue }
    }

    @Published private(set) var countries: [Country] = []
    @Published private(set) var filteredCountries: [Country] = []
    @Published private(set) var visibleCountries: [Country] = []
    @Published private(set) var state: LoadState = .idle
    @Published private(set) var errorMessage: String?
    @Published var searchText: String = "" {
        didSet {
            guard oldValue != searchText else { return }
            applyFilters()
        }
    }
    @Published var selectedRegion: RegionFilter = .all {
        didSet {
            guard oldValue != selectedRegion else { return }
            applyFilters()
        }
    }

    private let service: CountriesServiceProtocol
    private let pageSize: Int
    private var displayLimit: Int = 0

    init(service: CountriesServiceProtocol, pageSize: Int = 24) {
        self.service = service
        self.pageSize = max(1, pageSize)
    }

    func loadCountries() async {
        guard state != .loading else { return }
        state = .loading
        errorMessage = nil

        do {
            let result = try await service.fetchCountries().sorted { $0.displayName < $1.displayName }
            countries = result
            filteredCountries = result
            resetPagination()
            state = result.isEmpty ? .empty("No countries available.") : .loaded
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            errorMessage = message
            state = .failed(message)
        }
    }

    func refresh() async {
        await loadCountries()
    }

    private func applyFilters() {
        guard !countries.isEmpty else {
            filteredCountries = []
            visibleCountries = []
            errorMessage = nil
            return
        }

        filteredCountries = countries.filter { country in
            let matchesRegion: Bool = {
                guard selectedRegion != .all else { return true }
                return country.region?.caseInsensitiveCompare(selectedRegion.rawValue) == .orderedSame
            }()

            let matchesSearch: Bool = {
                guard !searchText.isEmpty else { return true }
                return country.displayName.localizedCaseInsensitiveContains(searchText) ||
                country.displayCapital.localizedCaseInsensitiveContains(searchText)
            }()

            return matchesRegion && matchesSearch
        }

        if filteredCountries.isEmpty {
            visibleCountries = []
            state = .empty("No results match your filters.")
            errorMessage = nil
        } else {
            resetPagination()
            state = .loaded
            errorMessage = nil
        }
    }

    func loadMoreIfNeeded(currentCountry country: Country) {
        guard state == .loaded else { return }
        guard let index = visibleCountries.firstIndex(where: { $0.id == country.id }) else { return }
        let thresholdIndex = visibleCountries.index(visibleCountries.endIndex, offsetBy: -5, limitedBy: visibleCountries.startIndex) ?? visibleCountries.startIndex

        if index >= thresholdIndex && displayLimit < filteredCountries.count {
            displayLimit = min(displayLimit + pageSize, filteredCountries.count)
            updateVisibleCountries()
        }
    }

    private func resetPagination() {
        displayLimit = min(pageSize, filteredCountries.count)
        updateVisibleCountries()
    }

    private func updateVisibleCountries() {
        visibleCountries = Array(filteredCountries.prefix(displayLimit))
    }
}

