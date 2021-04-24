//
//  CoreExtentions-Tests.swift
//  BitPriceTests
//
//  Created by Mike Jones on 3/2/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import XCTest
@testable import BitPrice

class CoreExtensionsTests: XCTestCase {

    class TestCell: UITableViewCell {}
    
    // MARK: - UITableViewCell
    func testUITableView_cellIdentifier() throws {
        XCTAssert(TestCell.cellIdentifier() == "TestCell")
    }
    
    // MARK: - String
    func testString_parseDate() throws {
        let date = String("2012-02-10").parseDate()
        XCTAssert(date.toShortString() == "Feb 10, 2012")
    }
    
    // MARK: - Date
    func testDate_toString() throws {
        let date = String("2012-02-10").parseDate()
        XCTAssert(date.toString() == "2012-02-10")
    }
    
    func testDate_toShortString() throws {
        let date = String("2012-02-10").parseDate()
        XCTAssert(date.toShortString() == "Feb 10, 2012")
    }

    // MARK: - BaseTableCellViewModel
    func testBaseTableCellViewModel_cellRowHeight() throws {
        let baseCell = BaseTableCellViewModel()
        XCTAssert(baseCell.cellRowHeight == 50.0)
    }
}


