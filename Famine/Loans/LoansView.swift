//
//  LoansView.swift
//  Famine
//
//  Created by Pongt Chia on 4/6/25.
//

import SwiftUI

struct LoansView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            
                        } label: {
                            Circle()
                                .frame(width: 75)
                                .overlay {
                                    Image(systemName: "plus")
                                        .foregroundStyle(.white)
                                }
                        }
                        .padding([.trailing, .bottom])
                    }
                }
            }
            .navigationTitle("Loans")
        }
    }
}

#Preview {
    LoansView()
}
