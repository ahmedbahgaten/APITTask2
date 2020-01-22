//
//  Configurator.swift
//  APIT Task2
//
//  Created by AHMED on 1/20/20.
//  Copyright © 2020 AHMED. All rights reserved.
//

import Foundation
class HomeConfigurator {
    static func Configure(homeViewController:HomeViewController) {
        let router = homeRouterImplementation(view: homeViewController)
        let presenter = homePresenterImplementation(view: homeViewController, router: router)
        homeViewController.presenter = presenter
        homeViewController.router = router
    }
}
