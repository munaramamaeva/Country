//
//  CountryRowView.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import Foundation
import SwiftUI

struct CountryRowView: View {
    let country: Country

    var body: some View {
        HStack(spacing: 16) {
            FlagView(url: country.flagURL)
                .frame(width: 60, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.gray.opacity(0.2))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(country.displayName)
                    .font(.headline)

                Text(country.displayCapital)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(country.displayRegion)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

private struct FlagView: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Image(systemName: "flag.slash.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
                    .padding(8)
            @unknown default:
                Image(systemName: "flag.2.crossed")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
                    .padding(8)
            }
        }
        .background(Color(.secondarySystemBackground))
    }
}
