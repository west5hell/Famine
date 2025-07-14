//
//  DebtAddView.swift
//  Famine
//
//  Created by Pongt Chia on 2/7/25.
//

import SwiftUI

struct DebtAddView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var amount: Decimal = 0
    @State private var startDate: Date = Date()
    @State private var showAlert = false
    
    var currentDebt: Debt? = nil
    var transactionAction: TransactionAction = .initial

    var body: some View {
        VStack {
            Form {
                Section {
                    if currentDebt == nil {
                        TextField("name", text: $name)
                    }

                    TextField(
                        "amount",
                        value: $amount,
                        format: .localCurrencySimple
                    )
                    .keyboardType(.decimalPad)

                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                }
            }

            Button("Save") {
                showAlert = true
            }
            .disabled(currentDebt != nil ? amount == 0 : (name.isEmpty || amount == 0))
            .buttonStyle(.borderedProminent)
        }
        .alert("Save?", isPresented: $showAlert) {
            Button("Save") {
                save()
            }
            
            Button("Cancel", role: .cancel) {
                
            }
        }
    }
    
    private func save() {
        defer {
            dismiss()
        }
        
        if let debt = currentDebt {
            let transaction = Transaction(amount: amount, startDate: startDate, action: transactionAction)
            debt.appendTransacation(transaction)
            return
        }
        
        let debt = Debt(action: .lentTo, name: name)
        let lent = Transaction(amount: amount, startDate: startDate)
        debt.appendTransacation(lent)

        modelContext.insert(debt)
    }
}

#Preview {
    DebtAddView()
}
