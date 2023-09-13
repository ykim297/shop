//
//  FavoriteCoordinator.swift
//  marvel
//
//  Created by Yong seok Kim on 2023/09/13.
//

import UIKit

class FavoriteCoordinator: BaseCoordinator {

    private var viewController: FavoriteViewController?
    
    
    required init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    override func start() {
        super.start()
        self.viewController = FavoriteViewController()
        if let vc = self.viewController {
            vc.viewModel = FavoriteViewModel(coordinator: self)
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
    
}

