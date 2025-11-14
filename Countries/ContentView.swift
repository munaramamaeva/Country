//
//  ContentView.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            CountryListView(viewModel: CountryListViewModel(service: CountriesService()))
        }
    }
}

#Preview {
    ContentView()
}
