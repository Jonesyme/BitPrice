//
//  DetailViewModel-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 3/02/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class DetailViewModelTests: XCTestCase {

    var webService: CoinDeskService!
    var detailViewBindingSpy: DetailViewBindingSpy!
    var detailViewModel: DetailViewModel?
    
    override func setUpWithError() throws {
        webService = CoinDeskServiceMock()
        detailViewBindingSpy = DetailViewBindingSpy()
        detailViewModel = DetailViewModel(webService: webService, selection: .live)
    }

    func testViewModelSetup() throws {
        XCTAssertNotNil(detailViewModel)
        XCTAssert(detailViewModel?.rowCount == 3)
        XCTAssertNotNil(self.detailViewModel?.item(atRow: 0))
        XCTAssertNotNil(self.detailViewModel?.item(atRow: 1))
        XCTAssertNotNil(self.detailViewModel?.item(atRow: 2))
    }
    
    func testViewBindingDelegate() {
        detailViewModel?.delegate = detailViewBindingSpy
        detailViewModel?.fetchData()
        delay {
            XCTAssert(self.detailViewBindingSpy.updateInvoked == true)
        }
    }
    
    func testTearDown() {
        detailViewModel?.tearDown()
        XCTAssert(detailViewModel?.taskList.count == 0)
    }
    
    func testTitle() {
        XCTAssert(detailViewModel?.title == Date().toShortString())
        let histDetailViewModel = DetailViewModel(webService: webService, selection: .historic(date: "2021-02-01".parseDate()))
        XCTAssert(histDetailViewModel.title == "2021-02-01".parseDate().toShortString())
    }
    
    func testFetchData() {
        detailViewModel?.fetchData()
        delay {
            let cellViewModel = self.detailViewModel?.item(atRow: 0)
            XCTAssertNotNil(cellViewModel)
            XCTAssert(cellViewModel?.priceRecord.value?.price == 49092.297)
            XCTAssert(cellViewModel?.priceRecord.value?.liveSource == true)
            XCTAssert(cellViewModel?.priceRecord.value?.currency == .USD)
        }
    }
    
    func testHistoricFetchData() {
        let histDetailViewModel = DetailViewModel(webService: webService, selection: .historic(date: "2021-03-01".parseDate()))
        histDetailViewModel.fetchData()
        delay {
            let cellViewModel = histDetailViewModel.item(atRow: 1)
            XCTAssertNotNil(cellViewModel)
            XCTAssert(cellViewModel.priceRecord.value?.price == 49619.643)
            XCTAssert(cellViewModel.priceRecord.value?.liveSource == false)
            XCTAssert(cellViewModel.priceRecord.value?.currency == .USD)
        }
    }
    
}


// helper class for testing delegate calls
class DetailViewBindingSpy: ViewModelBindingDelegate {
    public var updateInvoked = false
    func updateView(_ errorMessage: String?) {
        updateInvoked = true
    }
}


