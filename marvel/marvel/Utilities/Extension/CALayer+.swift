//
//  CALayer+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import QuartzCore

public extension CALayer {
    var isAnimating: Bool { return animationKeys()?.isEmpty == false }
}
