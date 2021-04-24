//
//  PriceRecord-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 3/2/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class PriceRecordTests: XCTestCase {

    var priceRecord: PriceRecord?
    
    override func setUpWithError() throws {
        priceRecord = PriceRecord(date: Date(), price: 999.999, currency: .USD, liveSource: true)
    }

    func testCurrencySymbol() throws {
        XCTAssert(priceRecord?.currencySymbol() == "$")
        priceRecord = PriceRecord(date: Date(), price: 999.999, currency: .BTC, liveSource: true)
        XCTAssert(priceRecord?.currencySymbol() == "₿")
        priceRecord = PriceRecord(date: Date(), price: 999.999, currency: .CNY, liveSource: true)
        XCTAssert(priceRecord?.currencySymbol() == "¥")
        priceRecord = PriceRecord(date: Date(), price: 999.999, currency: .GBP, liveSource: true)
        XCTAssert(priceRecord?.currencySymbol() == "£")
        priceRecord = PriceRecord(date: Date(), price: 999.999, currency: .EUR, liveSource: true)
        XCTAssert(priceRecord?.currencySymbol() == "€")
    }
    
    func testAttributtedPriceString() throws {
        let str = priceRecord?.attributedPriceString()
        XCTAssert(str?.string == "$999.999")
    }
}
