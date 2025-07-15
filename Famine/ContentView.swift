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
    @State private var addNewDebt: Bool = false
    @State private var isLentTo = false
    @State private var isBorrowedFrom = false

    private var totalLent: Decimal {
        debts
            .filter { $0.action == .lentTo }
            .reduce(Decimal.zero) { partialResult, debt in
                partialResult + debt.currentAmount
            }
    }

    private var totalBorrowed: Decimal {
        debts
            .filter { $0.action == .borrowedFrom }
            .reduce(Decimal.zero) { partialResult, debt in
                partialResult + debt.currentAmount
            }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Grid {
                    GridRow {
                        VStack {
                            Text("Lent:")
                                .padding(.top)
                                .padding(.bottom, 8)
                            Text(totalLent, format: .localCurrencySimple)
                                .fontWeight(.heavy)
                                .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.lent.opacity(0.6))
                        VStack {
                            Text("Borrowed:")
                                .padding(.top)
                                .padding(.bottom, 8)
                            Text(totalBorrowed, format: .localCurrencySimple)
                                .fontWeight(.heavy)
                                .padding(.bottom)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.borrowed.opacity(0.6))
                    }
                    .font(.title2)
                    .clipShape(.rect(cornerRadius: 10))
                }
                .padding(16)

                ScrollView {
                    LazyVStack {
                        ForEach(
                            debts,
                            content: { debt in
                                DebtRowView(debt: debt)
                                    .padding(.vertical, 8)
                                    .onTapGesture {
                                        selectedDebt = debt
                                    }
                            }
                        )
                    }
                    .sheet(item: $selectedDebt) { debt in
                        DebtDetailView(debt: debt)
                    }
                    .sheet(
                        isPresented: $isLentTo,
                        content: {
                            DebtAddView(debtAction: .lentTo)
                                .presentationDetents([.medium])
                        }
                    )
                    .sheet(
                        isPresented: $isBorrowedFrom,
                        content: {
                            DebtAddView(debtAction: .borrowedFrom)
                                .presentationDetents([.medium])
                        }
                    )
                    .confirmationDialog(
                        "Add New Debt",
                        isPresented: $addNewDebt,
                        actions: {
                            Button("Lent To") {
                                isLentTo.toggle()
                            }

                            Button("Borrowed From") {
                                isBorrowedFrom.toggle()
                            }

                            Button("Cancel", role: .cancel) {}
                        }
                    )
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Button("Add", systemImage: "plus") {
                                addNewDebt.toggle()
                            }
                            Button("Setting", systemImage: "gearshape") {

                            }
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
