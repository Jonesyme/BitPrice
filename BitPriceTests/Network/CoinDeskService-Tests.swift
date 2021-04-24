//
//  CoinDeskService-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class CoinDeskServiceTests: XCTestCase {
    
    var coinDeskService: CoinDeskService!
    
    override func setUp() {
        coinDeskService = CoinDeskServiceMock()
    }
    
    func testFetchLivePrice() {
        var priceList: PriceList?
        let expectation = self.expectation(description: "MockWebServiceCall")
        coinDeskService.fetchLivePrice(currency: .USD) { result in
            switch result {
            case .error(_):
                XCTFail()
            case .success(let response):
                priceList = response
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(priceList)
        XCTAssert(priceList?.prices.count == 1)
        XCTAssert(priceList?.prices[0].price == 49092.2983)
    }

    func testHistoricClosingPrice() {
        var priceList: PriceList?
        let expectation = self.expectation(description: "MockWebServiceCall")
        coinDeskService.fetchClosingPrice(onDate: Date(), currency: .EUR) { result in
            switch result {
            case .error(_):
                XCTFail()
            case .success(let response):
                priceList = response
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(priceList)
        guard let priceFeed = priceList?.prices else { return }
        XCTAssert(priceFeed.count == 1)
        XCTAssert(priceFeed[0].date.toString() == "2021-03-01")
        XCTAssert(priceFeed[0].price == 49619.6433)
    }
    
    func testHistoricClosingPrices() {
        var priceList: PriceList?
        let expectation = self.expectation(description: "MockWebServiceCall")
        coinDeskService.fetchClosingPrices(startDate: Date(), endDate: Date(), currency: .EUR) { result in
            switch result {
            case .error(_):
                XCTFail()
            case .success(let response):
                priceList = response
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(priceList)
        guard let priceFeed = priceList?.prices else { return }
        XCTAssert(priceFeed.count == 15)
        XCTAssert(priceFeed[0].date.toString() == "2021-03-01")
        XCTAssert(priceFeed[0].price == 41178.3992)
        XCTAssert(priceFeed[1].date.toString() == "2021-02-28")
        XCTAssert(priceFeed[1].price == 37477.2432)
        XCTAssert(priceFeed[2].date.toString() == "2021-02-27")
        XCTAssert(priceFeed[2].price == 38261.2487)
        XCTAssert(priceFeed[3].date.toString() == "2021-02-26")
        XCTAssert(priceFeed[3].price == 38377.6108)
        XCTAssert(priceFeed[4].date.toString() == "2021-02-25")
        XCTAssert(priceFeed[4].price == 38664.454)
    }
}
