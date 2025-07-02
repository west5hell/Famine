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

    @State private var inputText: String = ""
    @State private var numericValue: Decimal = 0.0

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale.current  // Use current locale for separators
        formatter.maximumFractionDigits = 2
        formatter.generatesDecimalNumbers = true
        return formatter
    }()

    var body: some View {
        VStack {
            Form {
                TextField("name", text: $name)

                TextField(
                    "amount",
                    value: $amount,
                    format: .localCurrencySimple
                )
                .keyboardType(.decimalPad)

                TextField("Enter amount", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .font(.title3)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: inputText) { oldValue, newValue in
                        formatInput(newValue)
                    }

                DatePicker(
                    "Start Date",
                    selection: $startDate,
                    displayedComponents: .date
                )
                
                Text(numericValue, format: .localCurrency)
            }

            Button("Save") {
                let debt = Debt(action: .lentTo, name: name)
                let lent = Transaction(amount: amount, startDate: startDate)
                debt.appendTransacation(lent)

                modelContext.insert(debt)
                dismiss()
                
            }
            .disabled(name.isEmpty || amount == 0)
            .buttonStyle(.borderedProminent)
        }
    }

    private func formatInput(_ input: String) {
            // Get locale-aware separators
            let groupingSeparator = numberFormatter.groupingSeparator ?? ","
            let decimalSeparator = numberFormatter.decimalSeparator ?? "."
            
            // Remove all formatting characters
            let cleanInput = input.replacingOccurrences(of: groupingSeparator, with: "")
            
            // Filter to only allow numbers and ONE decimal separator
            var filtered = ""
            var hasDecimalSeparator = false
            
            for char in cleanInput {
                if char.isNumber {
                    filtered.append(char)
                } else if String(char) == decimalSeparator && !hasDecimalSeparator {
                    hasDecimalSeparator = true
                    filtered.append(char)
                }
                // Ignore any additional decimal separators or invalid characters
            }
            
            // Handle empty input
            if filtered.isEmpty {
                numericValue = 0.0
                inputText = ""
                return
            }
            
            // Handle just decimal separator
            if filtered == decimalSeparator {
                numericValue = 0.0
                inputText = "0\(decimalSeparator)"
                return
            }
            
            // Update numeric value
            if let decimalValue = Decimal(string: filtered, locale: numberFormatter.locale) {
                numericValue = decimalValue
            }
            
            // Handle formatting while preserving decimal input
            if filtered.hasSuffix(decimalSeparator) {
                // User is typing decimal part, preserve the decimal separator
                let numberPart = String(filtered.dropLast())
                if numberPart.isEmpty {
                    inputText = "0\(decimalSeparator)"
                } else if let numberValue = Decimal(string: numberPart, locale: numberFormatter.locale),
                          let formattedNumber = numberFormatter.string(from: numberValue as NSDecimalNumber) {
                    inputText = formattedNumber + decimalSeparator
                }
            } else {
                // Normal formatting
                if let decimalValue = Decimal(string: filtered, locale: numberFormatter.locale),
                   let formattedString = numberFormatter.string(from: decimalValue as NSDecimalNumber) {
                    if formattedString != inputText {
                        inputText = formattedString
                    }
                }
            }
        }
}

#Preview {
    DebtAddView()
}
