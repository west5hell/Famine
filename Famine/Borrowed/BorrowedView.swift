//
//  BorrowedView.swift
//  Famine
//
//  Created by Pongt Chia on 5/7/25.
//

import SwiftUI

struct BorrowedView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Button("Dismiss") {
                dismiss()
            }
            .navigationTitle("Borrowed IN")
        }
    }
}

#Preview {
    BorrowedView()
}
