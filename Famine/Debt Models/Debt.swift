//
//  Debt.swift
//  Famine
//
//  Created by Pongt Chia on 30/6/25.
//

import SwiftData
import SwiftUI

@Model
class Debt {
    @Attribute(.unique)
    var debtID = UUID()

    var action: DebtAction
    var name: String
    var status: DebtStatus

    @Relationship(deleteRule: .cascade, inverse: \Transaction.debt)
    var transactions: [Transaction] = []
    var createdAt: Date
    var updatedAt: Date

    init(
        action: DebtAction,
        name: String,
        status: DebtStatus = .active,
        transactions: [Transaction] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.action = action
        self.name = name
        self.status = status
        self.transactions = transactions
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension Debt {
    var currentAmount: Decimal {
        transactions.reduce(0) { partialResult, transaction in
            partialResult + transaction.amount
        }
    }

    var displayDate: Date {
        transactions.compactMap(\.startDate).max() ?? createdAt
    }
    
    var sortedTransactions: [Transaction] {
        let sorted = transactions.sorted(by: { $0.startDate > $1.startDate })
        
        if let index = sorted.firstIndex(where: { $0.action == .initial }), index != sorted.count - 1 {
            let initial = sorted[index]
            initial.action = .increase
            
            let nonInitial = sorted[sorted.count - 1]
            nonInitial.action = .initial
        }
        
        return sorted
    }
    
    var isActive: Bool {
        status == .active
    }
    
    var isPaidoff: Bool {
        status == .paidoff
    }
    
    var isArchived: Bool {
        status == .archived
    }
}

extension Debt {
    func appendTransacation(_ transaction: Transaction) {
        transaction.debt = self
        transactions.append(transaction)
        
        updatedAt = transactions.compactMap(\.startDate).max() ?? Date()
    }

    func removeTransaction(_ transaction: Transaction) {
        transactions.removeAll { item in
            item.transactionID == transaction.transactionID
        }
        
        updatedAt = transactions.compactMap(\.startDate).max() ?? Date()
    }
    
    func paidoff() {
        let transaction = Transaction(
            amount: currentAmount,
            startDate: Date(),
            action: .decrease
        )
        
        appendTransacation(transaction)
        
        status = .paidoff
    }
    
    func restorePaidoff() {
        if !isPaidoff {
            return
        }
        
        if let lastesTransaction = transactions.max(by: { $0.startDate > $1.startDate }) {
            removeTransaction(lastesTransaction)
            status = .active
        }
    }
}

struct DebtNote: Codable {
    var note: String
    var attachedImages: [Data]
}

@Model
class Transaction {
    @Attribute(.unique)
    var transactionID = UUID()

    var amount: Decimal
    var startDate: Date
    var dueDate: Date?
    var note: DebtNote?
    var action: TransactionAction
    var debt: Debt? = nil

    init(
        amount: Decimal,
        startDate: Date,
        dueDate: Date? = nil,
        action: TransactionAction = .initial,
        note: DebtNote? = nil,
    ) {
        self.amount = amount
        self.startDate = startDate
        self.dueDate = dueDate
        self.action = action
        self.note = note
    }
}

extension Transaction {
    var amountText: Text {
        switch (action, debt?.action) {
        case (.increase, _), (.decrease, _):
            return Text(amount, format: .localCurrency)
            
        default:
            return Text(amount, format: .localCurrencySimple)
        }
    }
    
    var amountColor: Color {
        switch (action, debt?.action) {
        case (.increase, .lentTo), (.initial, .lentTo):
            return Color.lent
        case (.increase, .borrowedFrom), (.initial, .borrowedFrom):
            return Color.borrowed
        case (.decrease, .lentTo):
            return Color.borrowed
        case (.decrease, .borrowedFrom):
            return Color.lent
        case (_, .none):
            return .primary
        }
    }
    
    var displayTitle: String {
        switch (self.debt?.action, self.action) {
        case (.lentTo, .initial), (.lentTo, .increase):
            "I Lent To"
        case (.borrowedFrom, .initial), (.borrowedFrom, .increase):
            "I Borrowed From"
        case (.lentTo, .decrease):
            "I Received"
        case (.borrowedFrom, .decrease):
            "I Repaied"
        case (_, _):
            ""
        }
    }
}

enum DebtAction: Codable, CaseIterable {
    case lentTo
    case borrowedFrom
}

extension DebtAction {
    var display: String {
        switch self {
        case .lentTo:
            "Lent to"
        case .borrowedFrom:
            "Borrowed from"
        }
    }
    
    var color: Color {
        switch self {
        case .lentTo:
            Color.lent
        case .borrowedFrom:
            Color.borrowed
        }
    }
    var reversedColor: Color {
        switch self {
        case .lentTo:
            Color.borrowed
        case .borrowedFrom:
            Color.lent
        }
    }
}

enum DebtStatus: Codable, CaseIterable {
    case active
    case paidoff
    case archived
}

enum TransactionAction: Codable, CaseIterable {
    case initial
    case increase
    case decrease
}

extension TransactionAction {
    var displayIcon: Image {
        switch self {
        case .initial:
            Image(systemName: "chart.line.flattrend.xyaxis.circle")
        case .increase:
            Image(systemName: "chart.line.uptrend.xyaxis.circle")
        case .decrease:
            Image(systemName: "chart.line.downtrend.xyaxis.circle")
        }
    }
}
