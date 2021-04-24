//
//  DetailViewModel.swift
//  BitPrice
//
//  Created by Mike Jones on 2/25/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit


class DetailViewModel: BaseViewModel {

    private let currencyList: [CDCurrency] = [.EUR, .USD, .GBP]
    private var viewModels = [CurrencyCellViewModel]()
    private var selection: DetailViewSelection!
    internal var taskList = [URLSessionDataTask?]()
    
    
    public var title: String {
        switch selection {
        case .none:
            fallthrough
        case .live:
            return Date().toShortString()
        case .historic(let date):
            return date.toShortString()
        }
    }

    init(webService: CoinDeskService, selection: DetailViewSelection) {
        super.init(webService: webService)
        
        self.selection = selection
        viewModels.removeAll()
        for _ in currencyList {
            viewModels.append(CurrencyCellViewModel())
        }
    }
    
    public var rowCount: Int {
        return viewModels.count
    }
    
    public func item(atRow row: Int) -> CurrencyCellViewModel {
        return viewModels[row]
    }
    
    public func tearDown() {
        for task in taskList {
            if let task = task, task.state == .running {
                task.cancel() // cancel any active web requests
            }
        }
    }
    
    public func fetchData() {
        for i in 0..<currencyList.count {
            viewModels[i].isLoading.value = true
            var task: URLSessionDataTask? = nil
            switch selection {
            case .none: fallthrough
            case .live:
                task = webService.fetchLivePrice(currency: currencyList[i]) { [weak self] result in
                    switch result {
                    case .error(let error):
                        debugPrint(error.localizedDescription)
                    case .success(let response):
                        self?.viewModels[i].priceRecord.value = response.prices[0]
                    }
                    self?.viewModels[i].isLoading.value = false
                }
            case .historic(let date):
                task = webService.fetchClosingPrice(onDate: date, currency: currencyList[i]) { [weak self] result in
                    switch result {
                    case .error(let error):
                        debugPrint(error.localizedDescription)
                    case .success(let response):
                        self?.viewModels[i].priceRecord.value = response.prices[0]
                    }
                    self?.viewModels[i].isLoading.value = false
                }
            }
            if let task = task {
                taskList.append(task)
            }
            self.delegate?.updateView(nil)
        }
    }
    
}
