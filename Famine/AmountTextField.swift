//
//  AmountTextField.swift
//  Famine
//
//  Created by Pongt Chia on 15/7/25.
//

import SwiftUI

struct AmountTextField: View {
    @State private var textValue: String = ""
    @Binding var decimalValue: Decimal
    
    // 创建 NumberFormatter 用于格式化显示
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2 // 根据需要调整小数位数
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = Locale.current.groupingSeparator ?? ","
        formatter.decimalSeparator = Locale.current.decimalSeparator ?? "."
        return formatter
    }()
    
    var body: some View {
        TextField("0", text: $textValue)
            .keyboardType(.decimalPad)
            .multilineTextAlignment(.trailing)
            .onChange(of: textValue) { oldValue, newValue in
                handleTextChange(newValue)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hideKeyboard()
                    }
                }
            }
    }
    
    private func handleTextChange(_ newValue: String) {
        let decimalSeparator = formatter.decimalSeparator ?? "."
        let cleanedInput = newValue.filter { $0.isNumber || String($0) == decimalSeparator }
        
        let components = cleanedInput.components(separatedBy: decimalSeparator)
        var validInput = ""
        
        if components.count <= 2 {
            validInput = cleanedInput
        } else {
            validInput = components[0] + decimalSeparator + components[1...].joined()
        }
        
        // 处理只输入小数点的情况
        if validInput == decimalSeparator {
            textValue = "0" + decimalSeparator
            return
        }
        
        // 处理以小数点开头的情况
        if validInput.hasPrefix(decimalSeparator) {
            validInput = "0" + validInput
        }
        
        if let decimal = Decimal(string: validInput, locale: Locale.current) {
            decimalValue = decimal
            
            // 如果输入包含小数点但还在输入过程中，保持原始输入格式
            if validInput.hasSuffix(decimalSeparator) ||
               (validInput.contains(decimalSeparator) && validInput.components(separatedBy: decimalSeparator)[1].isEmpty) {
                textValue = validInput
            } else {
                // 格式化显示
                if let formattedString = formatter.string(from: NSDecimalNumber(decimal: decimal)) {
                    if textValue != formattedString {
                        textValue = formattedString
                    }
                }
            }
        } else if validInput.isEmpty {
            decimalValue = 0
            textValue = ""
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AmountTextField(decimalValue: .constant(0))
}
