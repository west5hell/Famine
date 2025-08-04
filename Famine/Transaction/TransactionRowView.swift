//
//  TransactionRowView.swift
//  Famine
//
//  Created by Pongt Chia on 30/6/25.
//

import SwiftUI

struct TransactionRowView: View {
    var transaction: Transaction
    
    var body: some View {
        HStack {
            HStack(spacing: 16) {
                transaction.action.displayIcon
                    .font(.largeTitle)

                VStack(alignment: .leading, spacing: 8) {
                    Text(transaction.displayTitle)
                        .bold()
                    Text(
                        transaction.startDate,
                        format: .dateTime.year().month(.twoDigits).day(
                            .twoDigits
                        )
                    )
                    .foregroundStyle(.secondary)
                }
            }

            Spacer()

            transaction.amountText
                .font(.headline)
                .foregroundStyle(transaction.amountColor)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(radius: 1)
    }

}

//#Preview {
//    TransactionRowView()
//}
