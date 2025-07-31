//
//  ArchivedView.swift
//  Famine
//
//  Created by Pongt Chia on 30/7/25.
//

import SwiftData
import SwiftUI

struct ArchivedView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Debt.updatedAt, order: .reverse) private var debts: [Debt]
    
    @State private var selectedDebt: Debt?

    var body: some View {
        NavigationStack {
            List {
                ForEach(debts.filter { $0.status != .active }) { debt in
                    DebtRowView(debt: debt)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            selectedDebt = debt
                        }
                }
            }
            .sheet(item: $selectedDebt, content: {
                DebtDetailView(debt: $0)
            })
            .listStyle(.plain)
            .navigationTitle("Archived")
        }
    }
}

#Preview {
    ArchivedView()
        .modelContainer(Debt.preview)
}
