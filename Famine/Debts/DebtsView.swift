//
//  DebtsView.swift
//  Famine
//
//  Created by Pongt Chia on 4/6/25.
//

import SwiftUI

struct DebtsView: View {
    @State private var present = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {

                }

                PlusNewButton(present: $present)

            }  //  ZStack
            .navigationTitle("Debts")
            .sheet(isPresented: $present) {
                Text("Add Debts")
            }

        }  //  NavigationStack
    }
}

#Preview {
    DebtsView()
}
