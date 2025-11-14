//
//  CountryDetailsView.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import SwiftUI

struct CountryDetailsView: View {
    let viewModel: CountryDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                AsyncImage(url: viewModel.flagURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 160)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 4)
                    case .failure:
                        Image(systemName: "flag.slash.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                    @unknown default:
                        EmptyView()
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.title)
                        .font(.largeTitle.weight(.bold))

                    Text(viewModel.subtitle)
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    Divider()

                    detailRow(title: "Official Name", value: viewModel.officialName)
                    detailRow(title: "Population", value: viewModel.populationText)
                    detailRow(title: "Area", value: viewModel.areaText)
                    detailRow(title: "Region", value: viewModel.region)
                    detailRow(title: "Subregion", value: viewModel.subregion)
                    detailRow(title: "Languages", value: viewModel.languages)
                    detailRow(title: "Timezones", value: viewModel.timezones)
                    detailRow(title: "Continents", value: viewModel.continents)
                    detailRow(title: "Coordinates", value: viewModel.coordinates)
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(value)
                .font(.body)
        }
    }
}
