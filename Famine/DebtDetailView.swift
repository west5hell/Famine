//
//  DebtDetailView.swift
//  Famine
//
//  Created by Pongt Chia on 30/6/25.
//

import SwiftUI

struct DebtDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.locale) private var locale

    @State private var isIncrement = false
    @State private var isDecrement = false
    @State private var payOff = false

    @State private var isRestore = false
    @State private var isArchive = false
    @State private var isDelete = false

    @State private var archiveConfirm = false
    @State private var deleteConfirm = false

    var debt: Debt

    private var displayTitle: String {
        debt.action.display + " " + debt.name
    }

    private var increaseText: String {
        switch debt.action {
        case .lentTo:
            "Lend More"
        case .borrowedFrom:
            "Borrow More"
        }
    }

    private var decreaseText: String {
        switch debt.action {
        case .lentTo:
            "Receive"
        case .borrowedFrom:
            "Repay"
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    switch debt.action {
                    case .lentTo:
                        HStack {
                            Text("I lent to \(debt.name) since")
                            Text(
                                debt.initialDate,
                                format: .dateTime.year().month(.twoDigits).day(
                                    .twoDigits
                                )
                            )
                        }
                        .font(.body.italic())
                        .opacity(0.5)
                        .shadow(radius: 1)
                    case .borrowedFrom:
                        HStack {
                            Text("I borrowed from \(debt.name) since")
                            Text(
                                debt.initialDate,
                                format: .dateTime.year().month(.twoDigits).day(
                                    .twoDigits
                                )
                            )
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
                
                if debt.isActive {
                    DebtDetailButtonsView(
                        isIncrement: $isIncrement,
                        isDecrement: $isDecrement,
                        payOff: $payOff,
                        debt: debt,
                        increaseText: increaseText,
                        decreaseText: decreaseText
                    )
                }
                
                Divider()

                Text("History")
                    .font(.largeTitle.bold())
                    .padding(.leading, 16)

                List {
                    ForEach(
                        debt.sortedTransactions
                    ) { transaction in
                        TransactionRowView(transaction: transaction)
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing) {
                                if debt.isActive && transaction.action != .initial {
                                    Button(role: .destructive) {
                                        debt.removeTransaction(transaction)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                            .onTapGesture {

                            }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle(debt.name)
            .alert("Delete this Debt?", isPresented: $deleteConfirm) {
                Button("Delete", role: .destructive) {
                    modelContext.delete(debt)

                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            }
            .alert("Archive this Debt?", isPresented: $archiveConfirm, actions: {
                Button("Archive", role: .destructive) {
                    debt.status = .archived

                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            })
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
                    NavigationLink {
                        DebtFolderView()
                            .navigationTitle("Debt Files")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Label("Files", systemImage: "folder.fill")
                    }
                    
                    if debt.isActive {
                        Button("Archive", systemImage: "archivebox") {
                            isArchive.toggle()
                        }
                        .confirmationDialog(
                            "Archive this Debt",
                            isPresented: $isArchive
                        ) {
                            Button("Archive") {
                                archiveConfirm.toggle()
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                    } else {
                        Button("Restore", systemImage: "tray.and.arrow.up.fill") {
                            isRestore.toggle()
                        }
                        .alert("Restore this Debt?", isPresented: $isRestore) {
                            Button("Cancel", role: .cancel) {}
                            
                            Button("Restore") {
                                if debt.isArchived {
                                    debt.status = .active
                                } else if debt.isPaidoff {
                                    debt.restorePaidoff()
                                }
                            }
                        }
                    }

                    Button("Delete", systemImage: "trash") {
                        isDelete.toggle()
                    }
                    .tint(Color.red)
                    .confirmationDialog(
                        "Delete this Debt",
                        isPresented: $isDelete
                    ) {
                        Button("Delete", role: .destructive) {
                            deleteConfirm.toggle()
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
            }
        }
    }
}

#Preview("borrow") {
    let levi = Debt(action: .borrowedFrom, name: "Levi", status: .archived)
    let lent = Transaction(
        amount: 10_000,
        startDate: Calendar.current.date(
            byAdding: .day,
            value: -10,
            to: Date()
        )!
    )
    levi.appendTransacation(lent)
    let lentMore = Transaction(
        amount: 5_000,
        startDate: Calendar.current.date(
            byAdding: .day,
            value: -16,
            to: Date()
        )!,
        action: .increase
    )
    levi.appendTransacation(lentMore)

    return DebtDetailView(debt: levi)
}

#Preview("lend") {
    let levi = Debt(action: .lentTo, name: "Levi")
    let lent = Transaction(
        amount: 10_000,
        startDate: Calendar.current.date(
            byAdding: .day,
            value: -10,
            to: Date()
        )!
    )
    levi.appendTransacation(lent)
    let lentMore = Transaction(
        amount: 5_000,
        startDate: Calendar.current.date(
            byAdding: .day,
            value: -6,
            to: Date()
        )!,
        action: .increase
    )
    levi.appendTransacation(lentMore)

    return DebtDetailView(debt: levi)
}
