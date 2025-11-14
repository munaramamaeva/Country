//
//  CountriesTests.swift
//  CountriesTests
//
//  Created by Munara Mamaeva on 14/11/25.
//

import XCTest
@testable import Countries

final class CountriesTests: XCTestCase {

    func testFetchCountriesReturnsNetworkResult() async throws {
        let countries = SampleData.countries
        let executor = NetworkExecutorMock(result: .success(countries))
        let service = CountriesService(networkExecutor: executor)

        let fetched = try await service.fetchCountries()

        XCTAssertEqual(fetched, countries)
        XCTAssertTrue(executor.didExecuteRequest)
    }

    func testFetchCountriesPropagatesNetworkError() async {
        let executor = NetworkExecutorMock(result: .failure(MockError.sample))
        let service = CountriesService(networkExecutor: executor)

        do {
            _ = try await service.fetchCountries()
            XCTFail("Expected to throw")
        } catch {
            XCTAssertTrue(error.localizedDescription.contains("sample error"))
        }
    }
    
    func testLoadCountriesSuccess() async throws {
        let countries = SampleData.countries
        let service = CountriesServiceMock(result: .success(countries))
        let viewModel = CountryListViewModel(service: service, pageSize: 2)

        await viewModel.loadCountries()

        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.visibleCountries.count, 2)
        XCTAssertEqual(viewModel.visibleCountries.first?.displayName, countries.first?.displayName)
    }

    func testLoadCountriesFailurePropagatesError() async {
        let service = CountriesServiceMock(result: .failure(MockError.sample))
        let viewModel = CountryListViewModel(service: service)

        await viewModel.loadCountries()

        guard case .failed(let message) = viewModel.state else {
            return XCTFail("Expected failed state")
        }
        XCTAssertTrue(message.contains("sample error"))
        XCTAssertEqual(viewModel.visibleCountries.count, 0)
    }

    func testSearchFiltersCountries() async throws {
        let countries = SampleData.countries
        let service = CountriesServiceMock(result: .success(countries))
        let viewModel = CountryListViewModel(service: service)

        await viewModel.loadCountries()
        viewModel.searchText = "nor"

        XCTAssertEqual(viewModel.visibleCountries.count, 1)
        XCTAssertEqual(viewModel.visibleCountries.first?.displayName, "Norway")
    }

    func testRegionFilterFiltersCountries() async throws {
        let countries = SampleData.countries
        let service = CountriesServiceMock(result: .success(countries))
        let viewModel = CountryListViewModel(service: service)

        await viewModel.loadCountries()
        viewModel.selectedRegion = .europe

        XCTAssertTrue(viewModel.visibleCountries.allSatisfy { $0.region == "Europe" })
    }

    func testPaginationLoadsMoreWhenNeeded() async throws {
        let countries = SampleData.largeCountriesList
        let service = CountriesServiceMock(result: .success(countries))
        let viewModel = CountryListViewModel(service: service, pageSize: 3)

        await viewModel.loadCountries()
        XCTAssertEqual(viewModel.visibleCountries.count, 3)

        let lastVisible = viewModel.visibleCountries.last!
        viewModel.loadMoreIfNeeded(currentCountry: lastVisible)

        XCTAssertEqual(viewModel.visibleCountries.count, 6)
    }
}

final class NetworkExecutorMock: NetworkExecuting {
    var result: Result<[Country], Error>
    private(set) var didExecuteRequest = false

    init(result: Result<[Country], Error>) {
        self.result = result
    }

    func execute<T>(_ request: URLRequest, as type: T.Type) async throws -> T where T : Decodable {
        didExecuteRequest = true
        switch result {
        case .success(let countries):
            guard let typed = countries as? T else {
                throw MockError.sample
            }
            return typed
        case .failure(let error):
            throw error
        }
    }
}

