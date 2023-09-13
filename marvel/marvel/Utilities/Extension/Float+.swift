//
//  Float+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import Foundation



extension Float {
    
    func difference(_ time: Float) -> (Bool, Float) {
        let targetTime = self
        let interval = targetTime - time
        let signal = interval >= 0 ? true : false
        let gap = fabsf(interval)
        
        return (signal, gap)
    }
    
    
}
