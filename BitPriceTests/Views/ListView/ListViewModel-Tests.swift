//
//  ListViewModel-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 3/2/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class ListViewModelTests: XCTestCase {

    var webService: CoinDeskServiceMock!
    var listViewBindingSpy: ListViewBindingSpy!
    var listViewModel: ListViewModel?
    
    override func setUpWithError() throws {
        webService = CoinDeskServiceMock()
        listViewBindingSpy = ListViewBindingSpy()
        listViewModel = ListViewModel(webService: webService)
    }

    func testViewModelSetup() throws {
        XCTAssertNotNil(listViewModel)
        XCTAssert(listViewModel?.rowCount == 15)
        XCTAssertNotNil(self.listViewModel?.item(atRow: 0) as? LivePriceCellViewModel)
        XCTAssertNotNil(self.listViewModel?.item(atRow: 1) as? PriceCellViewModel)
        XCTAssertNotNil(self.listViewModel?.item(atRow: 2) as? PriceCellViewModel)
    }
    
    func testFetchLivePrice() {
        listViewModel?.fetchLivePrice()
        delay {
            XCTAssert(self.listViewModel?.item(atRow: 0).priceRecord.value?.price == 49092.298)
            XCTAssert(self.listViewModel?.item(atRow: 0).priceRecord.value?.liveSource == true)
            XCTAssert(self.listViewModel?.item(atRow: 0).priceRecord.value?.currency == .USD)
        }
    }
    
    func testFetchHistoricPrices() {
        listViewModel?.fetchHistoricPrices()
        delay {
            XCTAssert(self.listViewModel?.item(atRow: 1).priceRecord.value?.date == "2021-03-01".parseDate())
            XCTAssert(self.listViewModel?.item(atRow: 1).priceRecord.value?.price == 41178.4)
            XCTAssert(self.listViewModel?.item(atRow: 1).priceRecord.value?.liveSource == false)
            XCTAssert(self.listViewModel?.item(atRow: 1).priceRecord.value?.currency == .EUR)
        }
    }
    
    func testViewBindingDelegate() {
        listViewModel?.delegate = listViewBindingSpy
        listViewModel?.fetchHistoricPrices()
        delay {
            XCTAssert(self.listViewBindingSpy.updateInvoked == true)
        }
    }
}


// helper class for testing delegate calls
class ListViewBindingSpy: ViewModelBindingDelegate {
    public var updateInvoked = false
    func updateView(_ errorMessage: String?) {
        updateInvoked = true
    }
}


