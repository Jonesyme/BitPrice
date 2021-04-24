//
//  PriceRecord.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit

//
// MARK: - Internal models
//

public struct PriceList {
    public var prices: [PriceRecord]
    public var currency: CDCurrency
    public var fetchedAt: Date
}

public struct PriceRecord {
    public var date: Date
    public var price: Float
    public var currency: CDCurrency?
    public var liveSource: Bool = false
}


extension PriceRecord {
    
    public func currencySymbol() -> String {
        switch currency {
        case .BTC:
            return "₿"
        case .USD:
            return "$"
        case .CNY:
            return "¥"
        case .GBP:
            return "£"
        case .EUR:
            return "€"
        case .none:
            fallthrough
        case .Default:
            return ""
        }
    }
    
    /// Format price using attributed fonts and baseline adjustment for the decimal portion
    public func attributedPriceString(fontSize: CGFloat = 20.0, decimals: Int = 3) -> NSAttributedString {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = self.currencySymbol()
        formatter.maximumFractionDigits = decimals
        formatter.minimumFractionDigits = decimals
        
        let full = formatter.string(from: NSNumber.init(value: self.price))
        let parts = full!.split(separator: ".").map(String.init)

        let prefixFont = [NSAttributedString.Key.font: UIFont.monospacedDigitSystemFont(ofSize: fontSize, weight: .regular)]
        let postfixFont = [NSAttributedString.Key.font: UIFont.monospacedDigitSystemFont(ofSize: fontSize-7, weight: .regular), NSAttributedString.Key.baselineOffset: 5.0] as [NSAttributedString.Key : Any]

        let string = NSMutableAttributedString(string: (parts[0] + "."), attributes: prefixFont)
        string.append(NSAttributedString(string: parts[1], attributes: postfixFont))
        return string
    }
}

