//
//  TransactionAddView.swift
//  Famine
//
//  Created by Pongt Chia on 16/7/25.
//

import SwiftUI

struct TransactionAddView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var amount: Decimal = 0
    @State private var transactionDate: Date = Date()

    var title: String
    var currentDebt: Debt
    var transactionAction: TransactionAction

    var body: some View {
        NavigationStack {
            VStack {
                Text(title)
                    .font(.largeTitle.weight(.heavy))
                Divider()
                LabeledContent("Amount") {
                    AmountTextField(decimalValue: $amount)
                }
                .padding(.vertical)
                Divider()
                LabeledContent("Date") {
                    DatePicker(
                        "",
                        selection: $transactionDate,
                        displayedComponents: .date
                    )
                }
                .padding(.vertical)
            }
            .font(.title2.bold())
            .padding()
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: 10))
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("dismiss", systemImage: "chevron.down") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let actuallyAmount =
                            transactionAction == .increase ? amount : -amount

                        let transaction = Transaction(
                            amount: actuallyAmount,
                            startDate: transactionDate,
                            action: transactionAction
                        )
                        currentDebt.appendTransacation(transaction)

                        dismiss()
                    }
                    .foregroundStyle(.white)
                    .disabled(amount == 0)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    TransactionAddView(
        title: "Lend More",
        currentDebt: Debt(action: .lentTo, name: "Bosh"),
        transactionAction: .increase
    )
}
