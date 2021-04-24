//
//  ViewModel.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit

protocol ViewModelBindingDelegate: class {
    func updateView(_ errorMessage: String?)
}

protocol ViewModelProtocol {
    var webService: CoinDeskService! { get set }
    var delegate: ViewModelBindingDelegate? { get set }
}

/// ViewModel Base Class
class BaseViewModel: ViewModelProtocol {
    weak var webService: CoinDeskService!
    weak var delegate: ViewModelBindingDelegate?
    
    init(webService: CoinDeskService) {
        self.webService = webService
    }
}
