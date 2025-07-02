//
//  DebtDetailView.swift
//  Famine
//
//  Created by Pongt Chia on 30/6/25.
//

import SwiftUI

struct DebtDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var debt: Debt

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(.primary)
                }
            }
        }
    }
}

//#Preview {
//    DebtDetailView()
//}
