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
            Tab("Lend Out", systemImage: "arrowshape.up.fill", value: 0) {
                Text("Lend Out")
            }

            Tab("Borrow In", systemImage: "arrowshape.down.fill", value: 1) {
                Text("Borrow In")
            }
        }
        .tint(selectedTab == 0 ? .red : .green)
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
