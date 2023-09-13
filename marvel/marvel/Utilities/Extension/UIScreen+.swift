//
//  UIScreen+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit

extension UIScreen {
    class var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    class var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var devicePixel: CGFloat { return 1 / scale }

    class var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }

    class var isLandscape: Bool { return !isPortrait }
        
    //  actual = 52.666667938232422, calculated = 52.666666666666671
    func roundToDevicePixels(_ value: CGFloat) -> CGFloat {
        return ceil(ceil(value * scale) / scale * 1_000) / 1_000
    }

    func roundDownToDevicePixels(_ value: CGFloat) -> CGFloat {
        return floor(value * scale) / scale
    }

    func middleOrigin(_ containerSizeValue: CGFloat, containedSizeValue: CGFloat) -> CGFloat {
        return roundDownToDevicePixels((containerSizeValue - containedSizeValue) / 2.0)
    }
    
    class var ratio: CGFloat {        
        return max(UIScreen.height, UIScreen.width)/844.0
    }
}
