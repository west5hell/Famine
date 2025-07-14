//
//  DebtDetailView.swift
//  Famine
//
//  Created by Pongt Chia on 30/6/25.
//

import SwiftUI

struct DebtDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.locale) private var locale

    @State private var isIncrement = false
    @State private var isDecrement = false
    @State private var payOff = false

    var debt: Debt

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(debt.currentAmount, format: .localCurrencySimple)
                    .foregroundStyle(
                        debt.action == .lentTo ? Color.lent : Color.borrowed
                    )
                    .font(.largeTitle.bold())
                    .padding(.leading, 16)

                HStack {
                    Spacer()
                    Button {
                        isIncrement.toggle()
                    } label: {
                        VStack {
                            Image(systemName: "arrowshape.up.fill")
                            Text("Increment")
                        }
                    }
                    .sheet(isPresented: $isIncrement) {
                        DebtAddView(currentDebt: debt, transactionAction: .increase)
                            .presentationDetents([.medium])
                    }

                    Button {
                        isDecrement.toggle()
                    } label: {
                        VStack {
                            Image(systemName: "arrowshape.down")
                            Text("Decrement")
                        }
                    }
                    .sheet(isPresented: $isDecrement) {
                        DebtAddView(currentDebt: debt, transactionAction: .decrease)
                            .presentationDetents([.medium])
                    }

                    Button {
                        payOff = true
                    } label: {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Pay Off")
                        }
                    }
                    .confirmationDialog(
                        "Pay Off Entire Debt",
                        isPresented: $payOff
                    ) {
                        Button("Pay Off Entire Debt") {

                        }
                        Button("Cancel", role: .cancel) {

                        }
                    }
                    Spacer()
                }

                Text("History")
                    .font(.largeTitle.bold())
                    .padding(.leading, 16)

                ScrollView {
                    LazyVStack {
                        ForEach(
                            debt.transactions.sorted(by: {
                                $0.startDate > $1.startDate
                            })
                        ) { transaction in
                            TransactionRowView(transaction: transaction)
                        }
                    }
                }
            }
            .navigationTitle(debt.name)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundStyle(
                                debt.action == .lentTo
                                    ? Color.lent : Color.borrowed
                            )
                    }
                    .tint(.primary)
                }
            }
        }
    }
}

#Preview {
    DebtDetailView(debt: Debt(action: .borrowedFrom, name: "Bosh"))
}
