//
//  AppCoordinator-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class AppCoordinatorTests: XCTestCase {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    override func setUp() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.appCoordinator = AppCoordinator(window: window)
        self.appCoordinator?.start()
    }

    func testCoordinatorSetup() throws {
        XCTAssertNotNil(appCoordinator?.window)
        XCTAssertNotNil(appCoordinator?.rootViewController)
    }
    
    func testStart() throws {
        XCTAssertNotNil(window?.rootViewController)
        XCTAssert(window?.isKeyWindow == true)
    }
    
    func testListCoordinatorStartInvoked() {
        let spy = ListCoordinatorSpy(presenter: window?.rootViewController as! UINavigationController, webService: CoinDeskService(webSession: WebSessionMock(.CurrentUSD)))
        appCoordinator?.listCoordinator = spy
        appCoordinator?.start()
        XCTAssert(spy.startInvoked == true)
    }

}

//  MARK: Spy classes
class ListCoordinatorSpy: ListCoordinator {
    public var startInvoked = false
    override func start() {
        startInvoked = true
    }
}
