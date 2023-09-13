//
//  UITableViewCell+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit


extension UITableViewCell {
    
    private struct currentIndexPath {
        static var section: Int = 0
        static var row: Int = 0
    }
    
    var section: Int {
        get {
            guard let section = objc_getAssociatedObject(self, &currentIndexPath.section) as? Int else {
                return 0
            }
            return section
        }
        set {
            objc_setAssociatedObject(self, &currentIndexPath.section, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var row: Int {
        get {
            guard let row = objc_getAssociatedObject(self, &currentIndexPath.row) as? Int else {
                return 0
            }
            return row
        }
        set {
            objc_setAssociatedObject(self, &currentIndexPath.row, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

}

