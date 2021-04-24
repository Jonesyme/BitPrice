//
//  ListViewController-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class ListViewControllerTests: XCTestCase {

    var navController: UINavigationController!
    var webService: CoinDeskServiceMock!
    var listCoordinator: ListCoordinator!
    var listViewModel: ListViewModel!
    var listViewController: ListViewController?
    
    override func setUpWithError() throws {
        navController = UINavigationController()
        webService = CoinDeskServiceMock()
        listCoordinator = ListCoordinator(presenter: navController, webService: webService)
        listViewModel = ListViewModel(webService: webService)
        listViewController = ListViewController.createInstance(viewModel: listViewModel, coordinator: listCoordinator)

        // override view bounds
        let view = listViewController?.view
        view?.bounds = UIScreen.main.bounds
        view?.layoutIfNeeded()
    }

    func testViewSetup() throws {
        XCTAssert(listViewController?.view != nil)
        XCTAssert(listViewController?.tableView != nil)
        XCTAssert(listViewController?.tableView.numberOfRows(inSection: 0) == 15)
    }

    func testLivePriceCellTablePopulation() {
        var livePriceCell: LivePriceCell?
        
        livePriceCell = self.listViewController?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LivePriceCell
        XCTAssertNotNil(livePriceCell)
        XCTAssert(livePriceCell?.priceLabel.text == nil)
        
        listViewModel?.fetchLivePrice()
        delay {
            livePriceCell = self.listViewController?.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? LivePriceCell
            XCTAssertNotNil(livePriceCell)
            XCTAssert(livePriceCell?.priceLabel.text == "$49,092.297")
        }
    }
    
    func testPriceCellTablePopulation() {
        var priceCell: PriceCell?
        listViewModel?.fetchHistoricPrices()
        delay {
            priceCell = self.listViewController?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? PriceCell
            XCTAssertNotNil(priceCell)
            XCTAssert(priceCell?.dateLabel.text == "Mar 01, 2021")
            XCTAssert(priceCell?.sourceLabel.text == "")
            XCTAssert(priceCell?.priceLabel.text == "€41,178.398")
            
            priceCell = self.listViewController?.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? PriceCell
            XCTAssertNotNil(priceCell)
            XCTAssert(priceCell?.dateLabel.text == "Feb 28, 2021")
            XCTAssert(priceCell?.sourceLabel.text == "")
            XCTAssert(priceCell?.priceLabel.text == "€37,477.242")
        }
    }
}

