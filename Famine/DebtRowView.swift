//
//  DebtRowView.swift
//  Famine
//
//  Created by Pongt Chia on 30/6/25.
//

import SwiftUI

struct DebtRowView: View {
    var debt: Debt
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "person.fill")
                    .font(.largeTitle)
                Text(debt.name)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text(debt.currentAmount, format: .localCurrencySimple)
                Text(
                    debt.displayDate,
                    format: .dateTime.year().month(.twoDigits).day(.twoDigits)
                )
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(radius: 1)
        .padding(.horizontal)
    }
    
}

//#Preview {
//    DebtRowView()
//}
