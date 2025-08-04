//
//  TransactionView.swift
//  Famine
//
//  Created by Pongt Chia on 4/8/25.
//

import SwiftUI

struct TransactionView: View {
    var transaction: Transaction

    var body: some View {
        VStack {
            Text(transaction.startDate, style: .date)
                .foregroundStyle(.secondary)
            Spacer()

            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 80))
                .padding()
                .background(.regularMaterial)
                .clipShape(.circle)

            Text("I Borrowed")
                .font(.title)

            transaction.amountText
                .font(.largeTitle.weight(.black))
            
            Spacer()

            HStack(spacing: 64) {
                Button {

                } label: {
                    Image(systemName: "trash")
                        .foregroundStyle(.white)
                        .padding()
                        .background(.pink)
                        .clipShape(.circle)
                }

                Button {

                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(.white)
                        .padding()
                        .background(.blue)
                        .clipShape(.circle)
                }
            }
            .font(.largeTitle)
        }
    }
}

#Preview {
    let transaction = Transaction(amount: 1_000, startDate: Date())

    return TransactionView(transaction: transaction)
}
