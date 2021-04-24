//
//  WebSession-Mock.swift
//  BitPriceTests
//
//  Created by Mike Jones on 3/2/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

/// Mockable WebService session - uses local response templates instead of making an outbound network request
class WebSessionMock: WebSession {

    enum ResponseMock: String {
        case CurrentUSD = "Current-USD"
        case CurrentUSDFailure = "Current-USD-Failure"
        case CurrentEUR = "Current-EUR"
        case CurrentGBP = "Current-GBP"
        case HistoricCloseUSD = "Historic-Close-USD"
        case HistoricBiWeekEUR = "Historic-BiWeek-EUR"
    }
    
    private var responseFilename: String = ResponseMock.CurrentUSD.rawValue
    
    init(_ responseMock: ResponseMock) {
        super.init()
        responseFilename = responseMock.rawValue
    }
    
    @discardableResult public override func request<T:Decodable>(_ endpoint: EndpointProtocol, responseType: T.Type, callback: @escaping WebSession.CompletionHandler<T>) -> URLSessionDataTask? {
        let path = Bundle(for: type(of: self)).path(forResource: responseFilename, ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        guard let validData = data else {
            assertionFailure()
            return nil
        }
        let decoded = self.decode(validData, targetType: T.self)
        switch decoded {
        case .success(let result):
            callback(.success(result))
        case .error(let error):
            callback(.error(error))
        }
        return nil
    }
}

