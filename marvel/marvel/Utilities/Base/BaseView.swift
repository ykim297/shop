//
//  BaseView.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit


protocol BaseLogic {
    func setComponent()
    func setAutoLayOut()
    func setRxFunction()
}

class BaseView: UIView, BaseLogic {
    let screenWidth = UIScreen.width
    let screenHeight = UIScreen.height
    
    let disposedBag = DisposeBag()

    
    func setComponent() {
        
    }
    
    func setAutoLayOut() {
        
    }
    
    func setRxFunction() {
        
    }
    
}
