//
//  CountryListView.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import Foundation
import SwiftUI

struct CountryListView: View {
    @ObservedObject var viewModel: CountryListViewModel
    
    var body: some View {
        content
            .navigationTitle("Countries")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Region", selection: $viewModel.selectedRegion) {
                        ForEach(CountryListViewModel.RegionFilter.allCases) { region in
                            Text(region.rawValue).tag(region)
                        }
                    }
                    .pickerStyle(.menu)
                    .accessibilityLabel("Filter countries by region")
                }
            }
        .searchable(text: $viewModel.searchText, prompt: "Search by name or capital")
        .task {
            await viewModel.loadCountries()
        }
        .background(Color(.systemBackground).ignoresSafeArea())
    }
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading countries...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded:
            countriesList
        case .empty(let message):
            EmptyStateView(message: message)
            EmptyView()
        case .failed(let message):
            ErrorStateView(message: message) {
                Task {
                    await viewModel.refresh()
                }
            }
        }
    }

    private var countriesList: some View {
        List(viewModel.visibleCountries) { country in
            NavigationLink(destination: CountryDetailsView(viewModel: CountryDetailsViewModel(country: country))) {
                CountryRowView(country: country)
            }
            .onAppear {
                viewModel.loadMoreIfNeeded(currentCountry: country)
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refresh()
        }
    }
}
