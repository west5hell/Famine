//
//  FamineEnums.swift
//  Famine
//
//  Created by Pongt Chia on 27/6/25.
//

import Foundation

enum FamineCategory: Codable, CaseIterable {
    case iLent
    case iBorrowed
    case loan
}

extension FamineCategory {
    var displayName: String {
        switch self {
        case .iLent:
            "I Lent"
        case .iBorrowed:
            "I Borrowed"
        case .loan:
            "Loan"
        }
    }
    
    
}

enum FaminePartyCategory: Codable, CaseIterable {
    case individual
    case bank
    case otherInstitutions
}

enum FamineChange: Codable, CaseIterable {
    case initial
    case increase
    case decrease
}


enum FamineStatus: Codable, CaseIterable {
    case active
    case settled
}
