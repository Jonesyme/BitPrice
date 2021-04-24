//
//  ListCoordinator.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit


class ListCoordinator: Coordinator {
    
    private weak var presenter: UINavigationController!
    private weak var webService: CoinDeskService!
    
    
    init(presenter: UINavigationController, webService: CoinDeskService) {
        self.presenter = presenter
        self.webService = webService
    }

    func start() {
        let listViewModel = ListViewModel(webService: webService)
        let listViewController = ListViewController.createInstance(viewModel: listViewModel, coordinator: self)
        presenter.pushViewController(listViewController, animated: true)
    }
    
    func showDetailView(forPriceRecord priceRecord: PriceRecord) {
        let userSelection: DetailViewSelection = (priceRecord.liveSource) ? .live : .historic(date: priceRecord.date)
        let detailCoordinator = DetailCoordinator(presenter: presenter, webService: webService, selection: userSelection)
        detailCoordinator.start()
    }
}
