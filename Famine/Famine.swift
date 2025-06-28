//
//  Famine.swift
//  Famine
//
//  Created by Pongt Chia on 27/6/25.
//

import SwiftData
import SwiftUI

@Model
class Famine {
    var lender: FamineParty
    var borrower: FamineParty
    var amount: Decimal

    var status: FamineStatus

    var histories: [FamineHistory] = []

    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    init(
        lender: FamineParty,
        borrower: FamineParty,
        amount: Decimal,
        status: FamineStatus,
        histories: [FamineHistory] = [],
        createdAt: Date,
        updatedAt: Date
    ) {
        self.lender = lender
        self.borrower = borrower
        self.amount = amount
        self.status = status
        self.histories = histories
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@Model
class FamineParty {
    var name: String
    var category: FaminePartyCategory

    @Relationship(inverse: \Famine.lender)
    var lentFamines: [Famine]?
    
    @Relationship(inverse: \Famine.borrower)
    var borrowedFamines: [Famine]?

    init(
        name: String,
        category: FaminePartyCategory = .individual,
        lentFamines: [Famine]? = nil,
        borrowedFamines: [Famine]? = nil
    ) {
        self.name = name
        self.category = category
        self.lentFamines = lentFamines
        self.borrowedFamines = borrowedFamines
    }
}

@Model
class FamineHistory {
    @Relationship(inverse: \Famine.histories)
    var famine: Famine
    
    var amount: Decimal

    var change: FamineChange

    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    init(
        famine: Famine,
        amount: Decimal,
        change: FamineChange,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.famine = famine
        self.amount = amount
        self.change = change
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
