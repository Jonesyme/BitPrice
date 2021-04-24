//
//  CoinDeskService-Mock.swift
//  BitPriceTests
//
//  Created by Mike Jones on 3/2/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

/// Mockable CoinDeskService - simply gauruntees that we use the correct mock-response file for whatever feed we're requesting
public class CoinDeskServiceMock: CoinDeskService {
    
    private var sessionOverride: WebSessionMock?

    init() {
        super.init(webSession: WebSessionMock(.CurrentUSD))
    }
    
    /// allows one to override the default session/response for each service call
    convenience init(overrideSession: WebSessionMock) {
        self.init()
        sessionOverride = overrideSession
    }

    @discardableResult public override func fetchClosingPrices(startDate: Date, endDate: Date, currency: CDCurrency, callback: @escaping CoinDeskCallback) -> URLSessionDataTask? {
        self.webSession = sessionOverride ?? WebSessionMock(.HistoricBiWeekEUR)
        return super.fetchClosingPrices(startDate: "2021-02-15".parseDate(), endDate: "2021-03-01".parseDate(), currency: .EUR, callback: callback)
    }
    
    @discardableResult public override func fetchClosingPrice(onDate: Date, currency: CDCurrency, callback: @escaping CoinDeskCallback) -> URLSessionDataTask? {
        self.webSession = sessionOverride ?? WebSessionMock(.HistoricCloseUSD)
        return super.fetchClosingPrice(onDate: "2021-03-01".parseDate(), currency: currency, callback: callback)
    }
    
    @discardableResult public override func fetchLivePrice(currency: CDCurrency, callback: @escaping CoinDeskCallback) -> URLSessionDataTask? {
        self.webSession = sessionOverride ?? WebSessionMock(.CurrentUSD)
        return super.fetchLivePrice(currency: .USD, callback: callback)
    }
    
}
