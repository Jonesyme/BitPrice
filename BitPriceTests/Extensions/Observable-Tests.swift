//
//  Observable-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class ObservableTests: XCTestCase {
    
    var testObservable: Observable<String>!

    override func setUp() {
        testObservable = Observable<String>(value: "initial")
    }
    
    func testSetup() {
        XCTAssert(testObservable.value == "initial")
    }
    
    func testObserverPattern() throws {
        var newValue: String? = nil
        let expectation = self.expectation(description: "ObserverPattern")
        testObservable.addObserver(fireNow: false) { value in
            newValue = value
            expectation.fulfill()
        }
        testObservable.value = "new"
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssert(newValue == "new")
    }
}

