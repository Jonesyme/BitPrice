//
//  DetailViewCoordinator.swift
//  BitPrice
//
//  Created by Mike Jones on 2/25/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit

public enum DetailViewSelection {
    case live
    case historic(date: Date)
}

class DetailCoordinator: Coordinator {
    
    private var selection: DetailViewSelection!
    private weak var presenter: UINavigationController!
    private weak var webService: CoinDeskService!
    
    
    init(presenter: UINavigationController, webService: CoinDeskService, selection: DetailViewSelection) {
        self.presenter = presenter
        self.webService = webService
        self.selection = selection
    }

    func start() {
        let detailViewModel = DetailViewModel(webService: webService, selection: selection)
        let detailViewController = DetailViewController.createInstance(viewModel: detailViewModel, coordinator: self)
        presenter.pushViewController(detailViewController, animated: true)
    }

}
