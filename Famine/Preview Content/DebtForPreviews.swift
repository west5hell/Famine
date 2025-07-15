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
        
        let sampleData: [(String, DebtAction, Decimal, Int)] = [
            ("Alice", .lentTo, 10_000, -10),
            ("Bob", .borrowedFrom, 5_000, -5),
            ("Charlie", .lentTo, 12_500, -15),
            ("Diana", .borrowedFrom, 7_800, -20),
            ("Ethan", .lentTo, 3_000, -3),
            ("Fiona", .borrowedFrom, 4_200, -8),
            ("George", .lentTo, 9_600, -12),
            ("Hannah", .borrowedFrom, 6_500, -18),
            ("Ivan", .lentTo, 11_000, -7),
            ("Julia", .borrowedFrom, 8_300, -14)
        ]

        for (name, action, amount, dayOffset) in sampleData {
            let debt = Debt(action: action, name: name)
            let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
            let transaction = Transaction(amount: amount, startDate: date)
            debt.appendTransacation(transaction)
            container.mainContext.insert(debt)
        }

        return container
    }
}
