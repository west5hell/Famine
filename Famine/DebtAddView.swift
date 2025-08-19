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
    @State private var amountString = ""
    @State private var startDate: Date = Date()
    @State private var showAlert = false
    @State private var debtNotes = ""

    @State private var showPhotos = false
    @State private var showFiles = false

    var currentDebt: Debt? = nil
    var debtAction: DebtAction = .lentTo
    var transactionAction: TransactionAction = .initial

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                if !name.isEmpty {
                    Text(
                        debtAction == .lentTo
                            ? "Who I lend to" : "Who I borrow from"
                    )
                    .bold()
                    .foregroundStyle(.white.opacity(0.5))
                }

                TextField(
                    "",
                    text: $name,
                    prompt: Text(
                        debtAction == .lentTo
                            ? "Who I lend to" : "Who I borrow from"
                    ).foregroundStyle(Color.white.opacity(0.5))
                )
                .foregroundStyle(Color.white)
                .font(.largeTitle.weight(.semibold))
            }
            .padding()
            .background(debtAction == .lentTo ? Color.lent : Color.borrowed)

            Spacer()

            Form {
                Section {
                    AmountTextField(decimalValue: $amount)
                        .font(.largeTitle.weight(.bold))
                } header: {
                    Text("Amount")
                }

                Section {
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: .date
                    )
                    .font(.headline)
                    .padding(.vertical, 4)
                }

                Section {
                    Button("Photos", systemImage: "photo.on.rectangle.angled") {
                        showPhotos.toggle()
                    }
                    .sheet(isPresented: $showPhotos) {
                        PhotosView()
                    }

                    Button("Files", systemImage: "folder") {
                        showFiles.toggle()
                    }
                    .sheet(isPresented: $showFiles) {
                        FilesView()
                    }

                } header: {
                    Text("Debt Evidences")
                }

                Section {
                    /**
                     ZStack(alignment: .topLeading) {
                         if debtNotes.isEmpty {
                             Text("Enter your note...")
                                 .foregroundColor(.gray)
                                 .padding(.horizontal, 8)
                                 .padding(.vertical, 12)
                         }

                         TextEditor(text: $debtNotes)
                             .padding(4)  // optional padding for better alignment
                     }
                     .frame(height: 150)  // adjust as needed
                     */
                    Text("You can add some notes here...")
                        .foregroundStyle(Color.gray)
                } header: {
                    Text("Debt Note")
                }
            }
            .headerProminence(.increased)

            Button("Save") {

            }
            .font(.largeTitle.weight(.bold))
        }
    }

    private func save() {
        defer {
            dismiss()
        }

        if let debt = currentDebt {
            let transaction = Transaction(
                amount: amount,
                startDate: startDate,
                action: transactionAction
            )
            debt.appendTransacation(transaction)
            return
        }

        let debt = Debt(action: debtAction, name: name)
        let lent = Transaction(amount: amount, startDate: startDate)
        debt.appendTransacation(lent)

        modelContext.insert(debt)
    }
}

#Preview {
    NavigationStack {
        DebtAddView()
    }
}
