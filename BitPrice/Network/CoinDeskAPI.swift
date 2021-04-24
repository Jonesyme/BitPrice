//
//  CoinDeskEndpoint.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit

//
// MARK: - CoinDeskAPI
//

public enum CoinDeskAPI {
    case current(_ code: CDCurrency)
    case historical(currency: CDCurrency, Start: Date, End: Date)
}

extension CoinDeskAPI: EndpointProtocol {

    public var scheme: WebSession.RequestScheme {
        return .HTTPS
    }
    
    public var requestMethod: WebSession.RequestMethod {
        return .GET
    }
    
    public var host: String {
        return "api.coindesk.com"
    }

    public var path: String {
        switch self {
        case .current(let currency):
            if currency == .Default {
                return "/v1/bpi/currentprice.json"
            } else {
                return "/v1/bpi/currentprice/" + currency.rawValue + ".json"
            }
        case .historical(_, _, _):
            return "/v1/bpi/historical/close.json"
        }
    }
    
    public var params: [URLQueryItem] {
        switch self {
        case .current(_):
            return []
        case .historical(let currency, let start, let end):
            return [URLQueryItem(name: "index", value: "USD/CNY"),
                    URLQueryItem(name: "currency", value: currency.rawValue),
                    URLQueryItem(name: "start", value: start.toString()),
                    URLQueryItem(name: "end", value: end.toString())]
        }
    }

}
