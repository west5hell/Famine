//
//  DebtDetailButtonsView.swift
//  Famine
//
//  Created by Pongt Chia on 31/7/25.
//

import SwiftUI

struct DebtDetailButtonsView: View {
    @Binding var isIncrement: Bool
    @Binding var isDecrement: Bool
    @Binding var payOff: Bool

    var debt: Debt
    var increaseText: String
    var decreaseText: String

    var body: some View {
        HStack {
            Button {
                isIncrement.toggle()
            } label: {
                VStack {
                    Image(systemName: "arrowshape.up.fill")
                        .font(.title)
                        .foregroundStyle(debt.action.color)
                        .padding(.bottom, 2)
                    Text(increaseText)
                }
            }
            .sheet(isPresented: $isIncrement) {
                TransactionAddView(
                    title: increaseText,
                    currentDebt: debt,
                    transactionAction: .increase
                )
                .presentationDetents([.medium])
            }

            Spacer()

            Button {
                isDecrement.toggle()
            } label: {
                VStack {
                    Image(systemName: "arrowshape.down")
                        .font(.title)
                        .foregroundStyle(debt.action.reversedColor)
                        .padding(.bottom, 2)
                    Text(decreaseText)
                }
            }
            .sheet(isPresented: $isDecrement) {
                TransactionAddView(
                    title: decreaseText,
                    currentDebt: debt,
                    transactionAction: .decrease
                )
                .presentationDetents([.medium])
            }
            Spacer()

            Button {
                payOff = true
            } label: {
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .padding(.bottom, 2)
                    Text("Pay Off")
                }
            }
            .confirmationDialog(
                "Pay Off Entire Debt",
                isPresented: $payOff
            ) {
                Button("Pay Off Entire Debt") {

                }
                Button("Cancel", role: .cancel) {}
            }
        }
        .font(.title3)
        .foregroundStyle(Color.primary)
        .padding()
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
        .padding()
    }
}

//#Preview {
//    DebtDetailButtonsView()
//}
