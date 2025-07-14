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
//                Image(systemName: "tray.and.arrow.up")
//                    .font(.largeTitle)
                switch transaction.action {
                case .initial:
                    Image(systemName: "chart.line.flattrend.xyaxis.circle")
                        .font(.largeTitle)
                case .increase:
                    Image(systemName: "chart.line.uptrend.xyaxis.circle")
                        .font(.largeTitle)
                case .decrease:
                    Image(systemName: "chart.line.downtrend.xyaxis.circle")
                        .font(.largeTitle)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(
                        Date(),
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
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(radius: 1)
        .padding(.horizontal)
    }

}

//#Preview {
//    TransactionRowView()
//}
