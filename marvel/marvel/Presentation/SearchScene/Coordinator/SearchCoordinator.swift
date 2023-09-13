//
//  SearchCoordinator.swift
//  marvel
//
//  Created by Yong seok Kim
//

import UIKit

class SearchCoordinator: BaseCoordinator {

    private var viewController: SearchViewController?
    
    
    required init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    override func start() {
        super.start()
        self.viewController = SearchViewController()
        if let vc = self.viewController {
            let useCase = DefaultSearchUseCase(repository: DefaultSearchRepository())

            vc.viewModel = SearchViewModel(coordinator: self, usecase: useCase)
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func dismiss() {
        self.navigationController.popViewController(animated: true)
    }
    
}
