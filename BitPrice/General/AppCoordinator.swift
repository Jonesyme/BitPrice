//
//  AppCoordinator.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    func start()
}

//
// MARK: - Primary Coordinator for App
//
class AppCoordinator: Coordinator {
    
    let window: UIWindow!
    let webSession: WebSession!
    let webService: CoinDeskService!
    let rootViewController = UINavigationController()
    var listCoordinator: ListCoordinator!

    init(window: UIWindow) {
        self.window = window
        self.webSession = WebSession()
        self.webService = CoinDeskService(webSession: self.webSession)
        self.listCoordinator = ListCoordinator(presenter: self.rootViewController, webService: self.webService)
    }

    func start() {
        window.rootViewController = rootViewController
        listCoordinator.start()
        window.makeKeyAndVisible()
    }
}
