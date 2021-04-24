//
//  DetailViewController-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 3/02/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class DetailViewControllerTests: XCTestCase {

    var navController: UINavigationController!
    var webService: CoinDeskServiceMock!
    var detailCoordinator: DetailCoordinator!
    var detailViewModel: DetailViewModel!
    var detailViewController: DetailViewController?
    
    override func setUpWithError() throws {
        navController = UINavigationController()
        webService = CoinDeskServiceMock()
        detailCoordinator = DetailCoordinator(presenter: navController, webService: webService, selection: .live)
        detailViewModel = DetailViewModel(webService: webService, selection: .live)
        detailViewController = DetailViewController.createInstance(viewModel: detailViewModel, coordinator: detailCoordinator)

        // override view bounds
        let view = detailViewController?.view
        view?.bounds = UIScreen.main.bounds
        view?.layoutIfNeeded()
    }

    func testViewSetup() throws {
        XCTAssert(self.detailViewController?.view != nil)
        XCTAssert(self.detailViewController?.tableView != nil)
        XCTAssert(self.detailViewController?.tableView.numberOfRows(inSection: 0) == 3)
    }

    func testTableCellPopulation() {
        var currencyCell: CurrencyCell?
        detailViewModel?.fetchData()
        delay {
            currencyCell = self.detailViewController?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CurrencyCell
            XCTAssertNotNil(currencyCell)
            XCTAssert(currencyCell?.currencyLabel.text == "USD")
            XCTAssert(currencyCell?.sourceLabel.text == "Live")
            XCTAssert(currencyCell?.priceLabel.text == "$49,092.297")
            
            currencyCell = self.detailViewController?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? CurrencyCell
            XCTAssertNotNil(currencyCell)
            XCTAssert(currencyCell?.currencyLabel.text == "USD")
            XCTAssert(currencyCell?.sourceLabel.text == "Live")
            XCTAssert(currencyCell?.priceLabel.text == "$49,092.297")
            
            currencyCell = self.detailViewController?.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? CurrencyCell
            XCTAssertNotNil(currencyCell)
            XCTAssert(currencyCell?.currencyLabel.text == "USD")
            XCTAssert(currencyCell?.sourceLabel.text == "Live")
            XCTAssert(currencyCell?.priceLabel.text == "$49,092.297")
        }
    }
}

