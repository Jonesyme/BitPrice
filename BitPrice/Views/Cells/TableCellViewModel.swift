//
//  TableCellViewModel.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit


protocol TableCellViewModel {
    var cellRowHeight: CGFloat { get }
    var isLoading: Observable<Bool> { get set }
    var priceRecord: Observable<PriceRecord?> { get set }
}

extension TableCellViewModel {
    var cellIdentifier: String {
        return String(describing: self).split(separator: ".")[1].replacingOccurrences(of: "ViewModel", with: "")
    }
}

class BaseTableCellViewModel: TableCellViewModel {
    var cellRowHeight: CGFloat { 50.0 }
    var isLoading = Observable<Bool>(value: true)
    var priceRecord = Observable<PriceRecord?>(value: nil)
}
