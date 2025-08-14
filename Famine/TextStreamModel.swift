//
//  TextStreamModel.swift
//  Famine
//
//  Created by Pongt Chia on 13/8/25.
//

import SwiftUI
import UIKit

@Observable
class TextStreamModel {
    var displayedText = ""
    var currentIndex = 0
    var isPaused = false
    private let fullText = "The example you saw earlier is a perfect example of a detached task that probably should not have been detached in the first place. Regardless of where the task runs exactly, and which context it was created in, we’re not blocking any threads with the work in this task."
    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init() {
        impactGenerator.prepare()
    }
    
    func startStreaming() {
        isPaused = false
        currentIndex = 0
        displayedText = ""
    }
    
    func updateText() {
        guard !isPaused, currentIndex < fullText.count else { return }
        let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
        displayedText = String(fullText[..<index])
        if fullText[index] != " " {
            impactGenerator.impactOccurred()
        }
        currentIndex += 1
    }
    
    func skipToEnd() {
        isPaused = true
        displayedText = fullText
        currentIndex = fullText.count
    }
}

struct StreamingTextView: View {
    @State private var model = TextStreamModel()
    
    var body: some View {
        VStack {
            Text(model.displayedText)
                .font(.body)
                .padding()
                .animation(.easeInOut, value: model.displayedText)
                .accessibilityLabel(model.displayedText)
                .accessibilityValue(model.displayedText)
                .gesture(
                    TapGesture()
                        .onEnded({ _ in
                            model.isPaused.toggle()
                        })
                )
            /**
             “The example you saw earlier is a perfect example of a detached task that probably should not have been detached in the first place. Regardless of where the task runs exactly, and which context it was created in, we’re not blocking any threads with the work in this task.”
             */
//            TextField("input some text...", text: $model.fullText)
//                .padding()
            
            Button("Skip") {
                model.skipToEnd()
            }
            .padding()
        }
        .onAppear {
            model.startStreaming()
        }
        .onReceive(Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()) { _ in
            model.updateText()
        }
        .onDisappear {
            model.isPaused = true
        }
    }
}

#Preview {
    StreamingTextView()
}
