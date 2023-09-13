//
//  BaseCoordinator.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit

enum CoordinatorType {
    case none
    case app
    case tab
}


protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorType { get }
    func start()
    func finish()
    
    init(navigationController: UINavigationController)
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

class BaseCoordinator: Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    var navigationController: UINavigationController
    var nextCoordinator: Coordinator?
    var type: CoordinatorType = .none
    var childCoordinators = [Coordinator]()
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
    }
    
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func tabFlow() {
        // Implementation Tab bar
        let tabCoordinator = TabCoordinator.init(navigationController: navigationController)
        tabCoordinator.finishDelegate = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

extension BaseCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
                
    }
}
