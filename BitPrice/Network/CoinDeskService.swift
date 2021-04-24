//
//  CoinDeskService.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import Foundation

/// CoinDesk WebService - interface between the app and the web-service client
public class CoinDeskService {
    
    public enum Response<T> {
        case success(T)
        case error(Error)
    }
    
    public typealias CoinDeskCallback = (CoinDeskService.Response<PriceList>) -> Void
    
    internal var webSession: WebSession!
    
    init(webSession: WebSession) {
        self.webSession = webSession
    }
    
    /// Fetch all closing prices within a specified date range
    /// - Returns: URLSessionDataTask instance so caller can cancel the request
    @discardableResult public func fetchClosingPrices(startDate: Date, endDate: Date, currency: CDCurrency, callback: @escaping CoinDeskCallback) -> URLSessionDataTask? {
        let task = webSession.request(CoinDeskAPI.historical(currency:currency, Start:startDate, End:endDate), responseType: CDHistResponse.self) { result in
            switch result {
            case .error(let error):
                DispatchQueue.main.async { callback(.error(error)) }
            case .success(let response):
                let result = CoinDeskService.normalizePriceFeed(response, currency: currency, sort: true)
                DispatchQueue.main.async {
                    if let result = result {
                        callback(.success(result))
                    } else {
                        callback(.error(WebSession.WSError.unknown))
                    }
                }
            }
        }
        task?.resume()
        return task
    }
    
    /// Fetch the historic closing price on a specified date
    /// - Returns: URLSessionDataTask instance so caller can cancel the request
    @discardableResult public func fetchClosingPrice(onDate: Date, currency: CDCurrency, callback: @escaping CoinDeskCallback) -> URLSessionDataTask? {
        let task = webSession.request(CoinDeskAPI.historical(currency:currency, Start:onDate, End:onDate), responseType: CDHistResponse.self) { result in
            switch result {
            case .error(let error):
                DispatchQueue.main.async { callback(.error(error)) }
            case .success(let response):
                let result = CoinDeskService.normalizePriceFeed(response, currency: currency)
                DispatchQueue.main.async {
                    if let result = result {
                        callback(.success(result))
                    } else {
                        callback(.error(WebSession.WSError.unknown))
                    }
                }
            }
        }
        task?.resume()
        return task
    }
    
    /// Fetch the latest, real-time price index in specified currency
    /// - Returns: URLSessionDataTask instance so caller can cancel the request
    @discardableResult public func fetchLivePrice(currency: CDCurrency, callback: @escaping CoinDeskCallback) -> URLSessionDataTask? {
        let task = webSession.request(CoinDeskAPI.current(currency), responseType: CDLiveResponse.self) { result in
            switch result {
            case .error(let error):
                DispatchQueue.main.async { callback(.error(error)) }
            case .success(let response):
                let result = CoinDeskService.normalizePriceFeed(response, currency: currency)
                DispatchQueue.main.async {
                    if let result = result {
                        callback(.success(result))
                    } else {
                        callback(.error(WebSession.WSError.unknown))
                    }
                }
            }
        }
        task?.resume()
        return task
    }
    
    /// Normalize, sort and convert a server-based price feed to our simplified object model
    /// - Parameters: Web-service response instance
    /// - Returns: PriceList or nil if failure
    public static func normalizePriceFeed<T>(_ response: T, currency: CDCurrency = .USD, sort: Bool = false) -> PriceList? {
        var priceList = [PriceRecord]()
        if let response = response as? CDHistResponse {
            for (dateString, priceFloat) in response.bpi {
                priceList.append(PriceRecord(date: dateString.parseDate(), price: priceFloat, currency: currency))
            }
        } else if let response = response as? CDLiveResponse {
            for (code, priceDaily) in response.bpi {
                if code == currency.rawValue {
                    priceList.append(PriceRecord(date: Date(), price: priceDaily.rateFloat, currency: currency, liveSource: true))
                }
            }
        }
        if sort { priceList.sort(by:{$0.date > $1.date}) }
        if priceList.count == 0 { return nil }
        return PriceList(prices: priceList, currency: currency, fetchedAt: Date())
    }
    
}
