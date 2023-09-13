//
//  UIFont+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit


//BebasNeue
extension UIFont {
    class func BebasNeue(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "BebasNeue-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func callAllFont() {
        UIFont.familyNames.sorted().forEach { familyName in
            print("*** \(familyName) ***")
            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                print("\(fontName)")
            }
            print("---------------------")
        }
    }
}
