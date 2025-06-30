//
//  FamineExtensions.swift
//  Famine
//
//  Created by Pongt Chia on 30/6/25.
//

import Foundation

extension FormatStyle where Self == Decimal.FormatStyle.Currency {
    static var localCurrency: Decimal.FormatStyle.Currency {
        let currencyCode = Locale.current.currency?.identifier ?? "USD"
        return .currency(code: currencyCode)
            .locale(Locale.current)
            .sign(strategy: .always())
    }
    
    // 简单版本（不显示正号）
    static var localCurrencySimple: Decimal.FormatStyle.Currency {
        let currencyCode = Locale.current.currency?.identifier ?? "USD"
        return .currency(code: currencyCode).locale(Locale.current)
    }
}
