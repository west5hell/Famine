//
//  FamineDetailView.swift
//  Famine
//
//  Created by Pongt Chia on 27/6/25.
//

import SwiftUI

struct FamineDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Spacer()
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "minus.square.fill")
                            Text("Decrease")
                                .font(.body)
                        }
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "plus.square.fill")
                            Text("Increase")
                                .font(.body)
                        }
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "checkmark.square.fill")
                            Text("Pay off")
                                .font(.body)
                        }
                    }
                    Spacer()
                }
                .font(.largeTitle)
                .foregroundStyle(.primary)
                .padding(.bottom)
                .background(.red)
                
                Text("History")
                    .font(.largeTitle.bold())
                    .padding(.leading, 16)
                ScrollView {
                    LazyVStack {
                        ForEach(0..<10, id: \.self) { _ in
                            FamineHistoryRowView()
                                .padding(.vertical, 8)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(.primary)
                }
            }
        }
    }
}

#Preview {
    FamineDetailView()
}
