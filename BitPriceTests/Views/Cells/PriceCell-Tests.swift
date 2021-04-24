//
//  PriceCell-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class PriceCellTests: XCTestCase {
    
    var tableView: UITableView!
    var cellViewModel: PriceCellViewModel!
    var cell: PriceCell? = nil
    
    override func setUpWithError() throws {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 400))
        tableView.register(nibName: PriceCell.cellIdentifier())
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PriceCell
        cellViewModel = PriceCellViewModel()
        cell?.configureCell(with: cellViewModel)
    }

    func testCellSetup() {
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell?.contentView)
        XCTAssert(cell?.loadingIdicator.isAnimating == true)
    }
    
    func testCellSpinnerBinding() {
        XCTAssert(cell?.loadingIdicator.isAnimating == true)
        cellViewModel.isLoading.value = false
        delay {
            XCTAssert(self.cell?.loadingIdicator.isAnimating == false)
        }
    }
    
    func testCellLabelsBinding() {
        XCTAssert(cell?.dateLabel.text == nil)
        XCTAssert(cell?.priceLabel.text == nil)
        
        let priceRecord = PriceRecord(date: "2021-01-01".parseDate(), price: 999.999, currency: .USD, liveSource: true)
        cellViewModel.priceRecord.value = priceRecord
        delay {
            XCTAssert(self.cell?.dateLabel.text == priceRecord.date.toShortString())
            XCTAssert(self.cell?.priceLabel.attributedText == priceRecord.attributedPriceString())
        }
    }
    
    func testCellPrepareForReuse() {
        cell?.prepareForReuse()
        let priceRecord = PriceRecord(date: "2021-02-02".parseDate(), price: 888.888, currency: .USD, liveSource: true)
        cellViewModel.priceRecord.value = priceRecord // binding should not occur
        delay {
            XCTAssert(self.cell?.priceLabel.attributedText != priceRecord.attributedPriceString())
        }
    }

}


// assists us in generating a proper table cell
extension PriceCellTests: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PriceCell.cellIdentifier(), for: indexPath)
        return cell
    }
}
