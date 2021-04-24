//
//  ListCoordinator-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class ListCoordinatorTests: XCTestCase {
    
    let webService = CoinDeskService(webSession: WebSessionMock(.CurrentUSD))
    let navController = UINavigationController()
    var listCoordinator: ListCoordinator?
    
    override func setUp() {
        listCoordinator = ListCoordinator(presenter: navController, webService: webService)
        listCoordinator?.start()
    }

    func testCoordinatorSetup() {
        XCTAssertNotNil(listCoordinator != nil)
    }
    
    func testInitialViewControllerLoaded() {
        if navController.topViewController is ListViewController {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }
    }

    func testShowDetailView() {
        let priceRecord = PriceRecord(date: Date(), price: 999.999, currency: .BTC, liveSource: true)
        listCoordinator?.showDetailView(forPriceRecord: priceRecord)
        delay(for: 1.0) {
            if self.navController.topViewController is DetailViewController {
                XCTAssertTrue(true)
            } else {
                XCTFail()
            }
        }

    }
}
