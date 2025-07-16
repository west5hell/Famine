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
    
    @State private var isArchive  = false
    @State private var isDelete = false

    var debt: Debt
    
    private var displayTitle: String {
        debt.action.display + " " + debt.name
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    switch debt.action {
                    case .lentTo:
                        HStack {
                            Text("I lent to \(debt.name) since")
                            Text(debt.createdAt, format: .dateTime.year().month(.twoDigits).day(.twoDigits))
                        }
                        .font(.body.italic())
                        .opacity(0.5)
                        .shadow(radius: 1)
                    case .borrowedFrom:
                        HStack {
                            Text("I borrowed from \(debt.name) since")
                            Text(debt.createdAt, format: .dateTime.year().month(.twoDigits).day(.twoDigits))
                        }
                        .font(.body.italic())
                        .opacity(0.5)
                        .shadow(radius: 1)
                    }
                    Text(debt.currentAmount, format: .localCurrencySimple)
                }
                .foregroundStyle(debt.action.color)
                .font(.largeTitle.bold())
                .padding(.leading, 16)

                HStack {
                    Button {
                        isIncrement.toggle()
                    } label: {
                        VStack {
                            Image(systemName: "arrowshape.up.fill")
                                .font(.title)
                                .foregroundStyle(debt.action.color)
                                .padding(.bottom, 2)
                            switch debt.action {
                            case .lentTo:
                                Text("Lend More")
                            case .borrowedFrom:
                                Text("Borrow More")
                            }
                        }
                    }
                    .sheet(isPresented: $isIncrement) {
                        TransactionAddView()
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
                            switch debt.action {
                            case .lentTo:
                                Text("Receive")
                            case .borrowedFrom:
                                Text("Repay")
                            }
                        }
                    }
                    .sheet(isPresented: $isDecrement) {
                        TransactionAddView()
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
                            .foregroundStyle(debt.action.color)
                    }
                }
            
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Archive", systemImage: "archivebox") {
                        isArchive.toggle()
                    }
                    .confirmationDialog("Archive this Debt", isPresented: $isArchive) {
                        Button("Archive") {
                            
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                    
                    Button("Delete", systemImage: "trash") {
                        isDelete.toggle()
                    }
                    .tint(Color.red)
                    .confirmationDialog("Delete this Debt", isPresented: $isDelete) {
                        Button("Delete", role: .destructive) {
                            
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
            }
        }
    }
}

#Preview {
    DebtDetailView(debt: Debt(action: .lentTo, name: "Bosh"))
    DebtDetailView(debt: Debt(action: .borrowedFrom, name: "Ellish"))
}
