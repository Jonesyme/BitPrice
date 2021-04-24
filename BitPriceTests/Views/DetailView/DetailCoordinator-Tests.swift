//
//  DetailCoordinator-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 3/02/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class DetailCoordinatorTests: XCTestCase {
    
    var webService: CoinDeskService!
    var navController: UINavigationController!
    var detailCoordinator: DetailCoordinator?
    
    override func setUp() {
        webService = CoinDeskServiceMock()
        navController = UINavigationController()
        let _ = navController.view
        
        detailCoordinator = DetailCoordinator(presenter: navController, webService: webService, selection: .live)
        detailCoordinator?.start()
    }

    func testCoordinatorSetup() {
        XCTAssertNotNil(detailCoordinator != nil)
    }
    
    func testDetailViewControllerPushed() {
        if navController.topViewController is DetailViewController {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }
    }

}
