//
//  ContentView.swift
//  Famine
//
//  Created by Pongt Chia on 31/12/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Debt.updatedAt, order: .reverse) private var debts: [Debt]
    @State private var selectedDebt: Debt?

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(
                        debts,
                        content: { debt in
                            DebtRowView(debt: debt)
                                .onTapGesture {
                                    selectedDebt = debt
                                }
                        }
                    )
                }
                .sheet(item: $selectedDebt) { debt in
                    DebtDetailView(debt: debt)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add", systemImage: "plus") {
                            let james = Debt(
                                action: .borrowedFrom,
                                name: "James"
                            )
                            let borrowed = Transaction(
                                amount: 20_000,
                                startDate: Calendar.current.date(
                                    byAdding: .day,
                                    value: -5,
                                    to: Date()
                                )!
                            )
                            james.appendTransacation(borrowed)

                            modelContext.insert(james)
                        }
                    }
                }
            }
            .navigationTitle("Famine")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(Debt.preview)
}
