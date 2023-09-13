//
//  UIWindow+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit

extension UIWindow {
    @available(iOS 13.0, *)
    func dismiss() {
        isHidden = true
        windowScene = nil
    }
}
