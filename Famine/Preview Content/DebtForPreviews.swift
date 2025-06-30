//
//  DebtForPreviews.swift
//  Famine
//
//  Created by Pongt Chia on 30/6/25.
//

import Foundation
import SwiftData

extension Debt {

    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Debt.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        let levi = Debt(action: .lentTo, name: "Levi")
        let lent = Transaction(amount: 10_000, startDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!)
        levi.appendTransacation(lent)
        let lentMore = Transaction(amount: 5_000, startDate: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, action: .increase)
        levi.appendTransacation(lentMore)
        
        container.mainContext.insert(levi)

        return container
    }
}
