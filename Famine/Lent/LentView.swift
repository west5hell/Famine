//
//  LentView.swift
//  Famine
//
//  Created by Pongt Chia on 5/7/25.
//

import SwiftUI

struct LentView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(0..<10, id: \.self) { index in
                        DebtRowView(debt: Debt(action: .lentTo, name: "Jack"))
                            .foregroundStyle(Color.lent)
                            .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Lent OUT")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("dismiss", systemImage: "chevron.down") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    
}

#Preview {
    LentView()
}
