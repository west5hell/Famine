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

    @Relationship(inverse: \Transaction.debt)
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
}

extension Debt {
    func appendTransacation(_ transaction: Transaction) {
        transaction.debt = self
        updatedAt = transaction.startDate
        transactions.append(transaction)
    }

    func removeTransaction() {

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
