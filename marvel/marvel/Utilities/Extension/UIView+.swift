//
//  UIView+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit

public typealias Spacer = UIView

public enum AnchorAxis: Int {
    case x
    case y
    case xy
}


extension UIView {
    // MARK: - Frame
    
    var parentViewController: UIViewController? {
            var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder!.next
                if let viewController = parentResponder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }

    var left: CGFloat {
        get { return frame.minX }
        set { frame.origin.x = newValue }
    }

    var right: CGFloat {
        get { return frame.maxX }
        set { frame.origin.x = newValue - width }
    }

    var top: CGFloat {
        get { return frame.minY }
        set { frame.origin.y = newValue }
    }

    var bottom: CGFloat {
        get { return frame.maxY }
        set { frame.origin.y = newValue - height }
    }

    var width: CGFloat {
        get { return frame.width }
        set { frame.size.width = newValue }
    }

    var height: CGFloat {
        get { return frame.height }
        set { frame.size.height = newValue }
    }

    private var contentWidth: CGFloat {
        return (self as? UIScrollView)?.contentSize.width ?? bounds.width
    }

    private var contentHeight: CGFloat {
        return (self as? UIScrollView)?.contentSize.height ?? bounds.height
    }
    
    func getRelativeWidthContraintValue(_ constant: CGFloat, guide: CGFloat = 414.0) -> CGFloat {
        let width = UIScreen.width
        let value =  (constant / guide) * width
        return value
    }
    
    func getRelativeHeightContraintValue(_ constant: CGFloat, guide: CGFloat = 414.0) -> CGFloat {
        let height = UIScreen.height
        let value =  (constant / guide) * height
        return value
    }

    // MARK: - Animation
    func fadeIn(duration: TimeInterval = 0.4) {
        DispatchQueue.main.async {
            self.isHidden = false            
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 1.0
            })
        }
    }

    func fadeOut(duration: TimeInterval = 0.4) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0.0
            }) { (complete) in
                self.isHidden = true
            }
        }
    }

    func removeFadeOut(duration: TimeInterval = 0.4) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }) { (complete) in
            self.removeFromSuperview()
        }
    }

    func startRotate(circle: Bool = true) {
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: .pi * -(circle ? 2.0 : 1.0))
        rotationAnimation.duration = 1
        rotationAnimation.isCumulative = true
//        rotationAnimation.repeatCount = .infinity
        self.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    func stopRotate() {
        self.layer.removeAnimation(forKey: "rotationAnimation")
    }
}


// MARK: - Builder

extension UIView {
    convenience init(backgroundColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setLayerBorder()
    }

}

extension UIView {
    @discardableResult
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
    
    @discardableResult
    func setShadow(radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float) -> UIView {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        return self
    }
    
    func subviews<T:UIView>(ofType WhatType:T.Type) -> [T] {
           var result = self.subviews.compactMap {$0 as? T}
           for sub in self.subviews {
               result.append(contentsOf: sub.subviews(ofType:WhatType))
           }
           return result
       }
}


extension UIView {
    
    func x() -> CGFloat {
        return self.frame.origin.x
    }

    func y() -> CGFloat {
        return self.frame.origin.y
    }

    func endX() -> CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    func endY() -> CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    //뷰의 위 아래 양옆의 코너를 라운드화 하기
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        
    }
    
    //Debug일시 뷰의 영역을 잡아준다.
    func setLayerBorder(color: UIColor = UIColor.randomColor, width: CGFloat = 0.5) {
//        let appManager = AppManager.shared
////        #if DEBUG
//        if appManager.getDesignQA() {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
//        }
//        #endif
    }
    
    func setLB(color: UIColor, width: CGFloat = 1.0) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func fitIntoSuperview(
        usingConstraints: Bool = false,
        usingLeadingTrailing: Bool = true,
        margins: UIEdgeInsets = .zero,
        autoWidth: Bool = false,
        autoHeight: Bool = false
    ) {
        guard let superview = superview else {
            return
        }
        if usingConstraints {
            translatesAutoresizingMaskIntoConstraints = false
            if usingLeadingTrailing {
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: margins.left).isActive = true
            } else {
                leftAnchor.constraint(equalTo: superview.leftAnchor, constant: margins.left).isActive = true
            }
            if autoWidth {
                if usingLeadingTrailing {
                    trailingAnchor.constraint(
                        equalTo: superview.trailingAnchor,
                        constant: -margins.right
                    ).isActive = true
                } else {
                    rightAnchor.constraint(
                        equalTo: superview.rightAnchor,
                        constant: -margins.right
                    ).isActive = true
                }
            } else {
                widthAnchor.constraint(
                    equalTo: superview.widthAnchor,
                    constant: -(margins.left + margins.right)
                ).isActive = true
            }
            topAnchor.constraint(equalTo: superview.topAnchor, constant: margins.top).isActive = true
            if autoHeight {
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -margins.bottom).isActive = true
            } else {
                heightAnchor.constraint(
                    equalTo: superview.heightAnchor,
                    constant: -(margins.top + margins.bottom)
                ).isActive = true
            }
        } else {
            translatesAutoresizingMaskIntoConstraints = true
            frame = superview.bounds.inset(by: margins)
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    func fitIntoSuperview() {
        fitIntoSuperview(
            usingConstraints: false,
            usingLeadingTrailing: true,
            margins: .zero,
            autoWidth: false,
            autoHeight: false
        )
    }
    
    func layer(withRoundedCorners corners: UIRectCorner, radius: CGFloat) -> CALayer {
            let layer = CAShapeLayer()
            layer.path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            ).cgPath
            return layer
        }
    
    func addBottomBorder(color: UIColor = UIColor.red, margins: CGFloat = 0, borderLineSize: CGFloat = 1) {
            let border = UIView()
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(border)
            border.addConstraint(NSLayoutConstraint(item: border,
                                                    attribute: .height,
                                                    relatedBy: .equal,
                                                    toItem: nil,
                                                    attribute: .height,
                                                    multiplier: 1, constant: borderLineSize))
            self.addConstraint(NSLayoutConstraint(item: border,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .bottom,
                                                  multiplier: 1, constant: 0))
            self.addConstraint(NSLayoutConstraint(item: border,
                                                  attribute: .leading,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .leading,
                                                  multiplier: 1, constant: margins))
            self.addConstraint(NSLayoutConstraint(item: border,
                                                  attribute: .trailing,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .trailing,
                                                  multiplier: 1, constant: margins))
        }
    }

