//
//  ContentView.swift
//  Famine
//
//  Created by Pongt Chia on 31/12/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    var localCurrencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }

    var body: some View {
        VStack {

        }
    }
}

#Preview {
    ContentView()
}
