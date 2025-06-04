//
//  PlusNewButton.swift
//  Famine
//
//  Created by Pongt Chia on 4/6/25.
//

import SwiftUI

struct PlusNewButton: View {
    @Binding var present: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()

                Button(
                    action: {
                        present.toggle()
                    },
                    label: {
                        Circle()
                            .frame(width: 75)
                            .overlay {
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                            }
                    }
                )
                .padding([.trailing, .bottom])
                .shadow(radius: 5)
            }
        }
    }
}

#Preview {
    PlusNewButton(present: .constant(false))
}
