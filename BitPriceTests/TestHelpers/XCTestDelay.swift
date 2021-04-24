//
//  XCTestDelay.swift
//  BitPriceTests
//
//  Created by Mike Jones on 2/24/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest

/// helper for testing view-binding patterns or any other delayed-fire event
extension XCTestCase {
    
    func delay(completion: @escaping (() -> Void)) {
        delay(for: 0.5, completion: completion)
    }
    
    func delay(for interval: TimeInterval, completion: @escaping (() -> Void)) {
        let exp = expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            completion()
            exp.fulfill()
        }
        waitForExpectations(timeout: interval + 0.5)
    }
}
