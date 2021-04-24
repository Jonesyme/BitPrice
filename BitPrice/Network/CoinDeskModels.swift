//
//  CoinDeskModels.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import Foundation

//
// MARK: CoinDeskAPI Models
//

/// currency options
public enum CDCurrency: String {
    case BTC = "BTC"
    case USD = "USD"
    case CNY = "CNY"
    case GBP = "GBP"
    case EUR = "EUR"
    case Default = ""
}

/// Response type for a historical price fetch
struct CDHistResponse: Codable {
    var time: CDTimeStamp
    var disclaimer: String
    var bpi: [String:Float]
}

/// Response type for a live price fetch
struct CDLiveResponse: Codable {
    var time: CDTimeStamp
    var disclaimer: String?
    var bpi: [String:CDLivePrice]
}

struct CDLivePrice: Codable {
    var code: String
    var symbol: String?
    var rate: String
    var description: String
    var rateFloat: Float
    enum CodingKeys: String, CodingKey {
        case code, symbol
        case rate
        case description
        case rateFloat = "rate_float"
    }
}

struct CDTimeStamp: Codable {
    var updated: String
    var updatedISO: String
}

