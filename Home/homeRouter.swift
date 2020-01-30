//
//  Router.swift
//  APIT Task2
//
//  Created by AHMED on 1/20/20.
//  Copyright © 2020 AHMED. All rights reserved.
//

import Foundation
import UIKit
protocol homeRouter:class {
//    var homeViewVar: homeView! {get set}
    func navigateToHomeScreen(viewController:HomeViewController)
}
class homeRouterImplementation:homeRouter {
    var homeView:homeViewProtocol!
    init(view:homeViewProtocol) {
        self.homeView = view
    }
    func navigateToHomeScreen(viewController: HomeViewController) {
        let savingScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SavingScreen") as! SavingScreenViewController
        savingScreen.SavingDelegate = viewController
        self.homeView.presentViewController(viewController: savingScreen)
    }
    
    
}
