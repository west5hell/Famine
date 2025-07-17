//
//  TransactionAddView.swift
//  Famine
//
//  Created by Pongt Chia on 16/7/25.
//

import SwiftUI

struct TransactionAddView: View {
    @State private var amount: Decimal = 0
    @State private var transactionDate: Date = Date()
    
    var body: some View {
        VStack {
            Text("Lend More")
                .font(.largeTitle.weight(.heavy))
            Divider()
            LabeledContent("Amount") {
                AmountTextField(decimalValue: $amount)
            }
            .padding(.vertical)
            Divider()
            LabeledContent("Date") {
                DatePicker("", selection: $transactionDate, displayedComponents: .date)
            }
            .padding(.vertical)
            Divider()
            Button("Save") {
                
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
        }
        .font(.title2.bold())
        .padding()
        .background(.thinMaterial)
        .clipShape(.rect(cornerRadius: 10))
        .padding()
    }
}

#Preview {
    TransactionAddView()
}
