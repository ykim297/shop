//
//  AppCoordinator.swift
//  marvel
//
//  Created by Yong seok Kim
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    required init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    override func start() {
        super.start()
        let searchCoordinator = SearchCoordinator(navigationController: self.navigationController)
        searchCoordinator.start()
    }
}
