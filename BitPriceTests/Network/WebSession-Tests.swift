//
//  WebSession-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class WebSessionTests: XCTestCase {
    
    var webSessionMock: WebSessionMock!
    
    func testCurrentUSDRequest() {
        webSessionMock = WebSessionMock(.CurrentUSD)
        var priceFeed = [PriceRecord]()
        let expectation = self.expectation(description: "MockRequest")
        webSessionMock.request(CoinDeskAPI.current(.USD), responseType: CDLiveResponse.self) { result in
            switch result {
            case .error(_):
                XCTFail()
            case .success(let response):
                for (code, priceDaily) in response.bpi {
                    if code == CDCurrency.USD.rawValue {
                        priceFeed.append(PriceRecord(date: Date(), price: priceDaily.rateFloat, currency: CDCurrency.USD, liveSource: true))
                    }
                }
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(priceFeed.count == 1)
        XCTAssert(priceFeed[0].price == 49092.2983)
    }

    func testHistoricCloseUSDRequest() {
        webSessionMock = WebSessionMock(.CurrentUSDFailure)
        var errorMsg = ""
        let expectation = self.expectation(description: "MockRequest")
        webSessionMock.request(CoinDeskAPI.historical(currency: .USD, Start: Date(), End: Date()), responseType: CDHistResponse.self) { result in
            switch result {
            case .error(let error):
                errorMsg = error.localizedDescription
                expectation.fulfill()
            case .success(_):
                XCTFail()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        debugPrint(errorMsg)
        XCTAssert(errorMsg.range(of: "Parsing error") != nil)
    }

    func testHistoricBiWeekEURRequest() {
        webSessionMock = WebSessionMock(.HistoricBiWeekEUR)
        var priceList: PriceList?
        let expectation = self.expectation(description: "MockRequest")
        webSessionMock.request(CoinDeskAPI.historical(currency: .EUR, Start: Date(), End: Date()), responseType: CDHistResponse.self) { result in
            switch result {
            case .error(_): XCTFail()
            case .success(let response):
                priceList = CoinDeskService.normalizePriceFeed(response, currency: .EUR, sort: true)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        guard let priceFeed = priceList?.prices else {
            XCTFail()
            return
        }
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
