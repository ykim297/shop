//
//  Reusable.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import Foundation

public protocol Reusable {
    static var identifier: String { get }
}

public extension Reusable {
    /// By default, use the name of the class as String for its identifier
    static var identifier: String {
        return String(describing: self)
    }
}
