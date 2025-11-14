//
//  EmptyListView.swift
//  Countries
//
//  Created by Munara Mamaeva on 14/11/25.
//

import Foundation
import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let systemImage: String

    init(title: String = "No Results", message: String, systemImage: String = "magnifyingglass.circle") {
        self.title = title
        self.message = message
        self.systemImage = systemImage
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.title3.bold())

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
