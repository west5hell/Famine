//
//  SettingsView.swift
//  Famine
//
//  Created by Pongt Chia on 15/7/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var iCloud = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Label("Archived", systemImage: "archivebox")
                }
                
                Section {
                    Toggle("iCloud", isOn: $iCloud)
                }
                
                Section {
                    Label("Support", systemImage: "lasso.badge.sparkles")
                    Label("Rating", systemImage: "star")
                    Label("Share", systemImage: "square.and.arrow.up")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Dismiss", systemImage: "chevron.down") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
