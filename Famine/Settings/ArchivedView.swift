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

    var body: some View {
        NavigationStack {
            List {
                ForEach(debts.filter { $0.status == .archived }) {
                    DebtRowView(debt: $0)
                        .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Archived")
        }
    }
}

#Preview {
    ArchivedView()
        .modelContainer(Debt.preview)
}
