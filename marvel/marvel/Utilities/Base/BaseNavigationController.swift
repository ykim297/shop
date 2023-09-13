//
//  BaseNavigationController.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    public var requiredStatusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        requiredStatusBarStyle
    }
    
    open override var childForStatusBarStyle: UIViewController? {
         return visibleViewController
     }
}
