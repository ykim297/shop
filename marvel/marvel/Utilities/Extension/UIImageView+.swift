//
//  UIImageView+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit


extension UIImageView {
    func twinkle() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.alpha = 0
        }
    }

}
