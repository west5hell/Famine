//
//  ContentView.swift
//  Famine
//
//  Created by Pongt Chia on 31/12/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var isPresented = false

    var localCurrencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(0..<10, id: \.self) { _ in
                        FamineRowView()
                    }
                    .onTapGesture {
                        isPresented.toggle()
                    }
                }
                .sheet(isPresented: $isPresented) {
                    FamineDetailView()
                }
            }
            .navigationTitle("Famine")
        }
    }
}

#Preview {
    ContentView()
}
