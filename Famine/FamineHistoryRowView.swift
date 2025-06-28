//
//  FamineHistoryRowView.swift
//  Famine
//
//  Created by Pongt Chia on 28/6/25.
//

import SwiftUI

struct FamineHistoryRowView: View {

    var body: some View {
        HStack {
            HStack(spacing: 16) {
                Image(systemName: "tray.and.arrow.up")
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 8) {
                    Text(
                        Date(),
                        format: .dateTime.year().month(.twoDigits).day(
                            .twoDigits
                        )
                    )
                    .foregroundStyle(.secondary)

                    Text("I received")
                        .font(.title2)
                }
            }

            Spacer()

            Text(
                10_000,
                format: .currency(code: localCurrencyCode).locale(
                    Locale.current
                )
            )
            .font(.headline)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(radius: 1)
        .padding(.horizontal)
    }

    var localCurrencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
}

#Preview {
    FamineHistoryRowView()
}
