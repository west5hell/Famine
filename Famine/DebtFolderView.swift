//
//  DebtFolderView.swift
//  Famine
//
//  Created by Pongt Chia on 2/8/25.
//

import SwiftUI

struct DebtFolderView: View {
    var body: some View {
        Form {
            Section {
                NavigationLink("Photos") {
                    
                }
            } header: {
                Text("Photos")
            }

            Section {
                Text("Files")
            } header: {
                Text("Files")
            }
            
            Section {
                Text("Records")
            } header: {
                Text("Records")
            }
        }
        .headerProminence(.increased)
    }
}

#Preview {
    NavigationStack {
        DebtFolderView()
            .navigationTitle("Debt Files")
    }
}
