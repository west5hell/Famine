//
//  FamineApp.swift
//  Famine
//
//  Created by Pongt Chia on 31/12/24.
//

import SwiftUI
import SwiftData

@main
struct FamineApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Debt.self)
        }
    }
}
