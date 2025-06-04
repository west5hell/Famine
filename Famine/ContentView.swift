//
//  ContentView.swift
//  Famine
//
//  Created by Pongt Chia on 31/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Debts", systemImage: "arrowshape.down.fill", value: 0) {
                DebtsView()
            }

            Tab("Loans", systemImage: "arrowshape.up.fill", value: 1) {
                LoansView()
            }
        }
        .tint(selectedTab == 0 ? .red : .green)
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
