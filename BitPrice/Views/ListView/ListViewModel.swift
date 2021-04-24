//
//  ListViewModel.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit

class ListViewModel: BaseViewModel {

    private static let dailySpread: Int = 14
    private var viewModels: [TableCellViewModel]!


    override init(webService: CoinDeskService) {
        super.init(webService: webService)
        viewModels = [TableCellViewModel]()
        viewModels.append(LivePriceCellViewModel())
        for _ in 1...ListViewModel.dailySpread {
            viewModels.append(PriceCellViewModel())
        }
    }
    
    public var rowCount: Int {
        return viewModels.count
    }
    
    public func item(atRow row: Int) -> TableCellViewModel {
        return viewModels[row]
    }

    public func fetchLivePrice() {
        viewModels[0].isLoading.value = true
        webService.fetchLivePrice(currency: .EUR) { [weak self] result in
            switch result {
            case .error(let error):
                debugPrint("Live fetch failed: " + error.localizedDescription)
            case .success(let response):
                self?.viewModels[0].priceRecord.value = response.prices[0]
            }
            self?.viewModels[0].isLoading.value = false
        }
    }
    
    public func fetchHistoricPrices() {
        viewModels.forEach({$0.isLoading.value = true})
        let startDate = Date().addingTimeInterval(TimeInterval(-86400 * ListViewModel.dailySpread))
        webService.fetchClosingPrices(startDate: startDate, endDate: Date(), currency: .EUR) { [weak self] result in
            switch result {
            case .error(let error):
                self?.delegate?.updateView(error.localizedDescription)
            case .success(let response):
                for i in 1...ListViewModel.dailySpread {
                    if i > response.prices.count { break }
                    self?.viewModels[i].priceRecord.value = response.prices[i-1]
                    self?.viewModels[i].isLoading.value = false
                }
                self?.delegate?.updateView(nil)
            }
        }
    }

}
