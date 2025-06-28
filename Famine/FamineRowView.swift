//
//  FamineRowView.swift
//  Famine
//
//  Created by Pongt Chia on 27/6/25.
//

import SwiftUI

struct FamineRowView: View {
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "person.fill")
                    .font(.largeTitle)
                Text("John Doe")
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text(
                    10_000,
                    format: .currency(code: localCurrencyCode).locale(
                        Locale.current
                    )
                )
                Text(
                    Date(),
                    format: .dateTime.year().month(.twoDigits).day(.twoDigits)
                )
            }
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
    FamineRowView()
}
