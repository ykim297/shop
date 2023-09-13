//
//  UIbutton+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit
import RxSwift

extension Reactive where Base: UIButton {
    var isHighlighted: Observable<Bool> {
        let anyObservable = self.base.rx.methodInvoked(#selector(setter: self.base.isHighlighted))

        let boolObservable = anyObservable
            .flatMap { Observable.from(optional: $0.first as? Bool) }
            .startWith(self.base.isHighlighted)
            .distinctUntilChanged()
            .share()

        return boolObservable
    }
}

extension UIButton {
    private func imageWithColor(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(imageWithColor(color: color), for: state)
    }
    
    func alignmentRectInsets(left: Bool) -> UIEdgeInsets {
        let insets: UIEdgeInsets
        if (left) {
            insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        }
        else { // IF_ITS_A_RIGHT_BUTTON
            insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        }
        return insets;

    }
    
    func alignTextUnderImage(spacing: CGFloat = 4.0) {
            if let image = imageView?.image {
                let imageSize: CGSize = image.size
                titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -imageSize.height, right: 0.0)
                let labelString = NSString(string: titleLabel!.text!)
                let titleSize = labelString.size(
                    withAttributes: [NSAttributedString.Key.font: titleLabel!.font as Any]
                )
                imageEdgeInsets = UIEdgeInsets(
                    top: -(titleSize.height + spacing),
                    left: 0.0,
                    bottom: 0.0,
                    right: -titleSize.width
                )
            }
        }
    
    func alignImageNextText(spacing: CGFloat = 4.0) {
        if let image = imageView?.image {
            let imageSize: CGSize = image.size
            
            let labelString = NSString(string: titleLabel!.text!)
            let titleSize = labelString.size(
                withAttributes: [NSAttributedString.Key.font: titleLabel!.font as Any]
            )
            
            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -imageSize.width)
            imageEdgeInsets = UIEdgeInsets(
                top: 0.0,
                left: 0.0,
                bottom: 0.0,
                right: spacing
            )

//            titleEdgeInsets = UIEdgeInsets(top: 0.0, left: spacing, bottom: 0.0, right: -titleSize.width/2)
//            imageEdgeInsets = UIEdgeInsets(
//                top: 0.0,
//                left: 0.0,
//                bottom: 0.0,
//                right: 0.0
//            )
        }
    }
}

extension UIButton {
    func imageWithtext(spacing: CGFloat) {
        self.imageView?.setLayerBorder()
        self.titleLabel?.setLayerBorder()
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        self.titleEdgeInsets.left = spacing
        self.contentHorizontalAlignment = .left
    }
    
    func textWithImage(spacing: CGFloat) {
        self.imageView?.setLayerBorder()
        self.titleLabel?.setLayerBorder()
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        self.titleEdgeInsets.right = spacing
        self.contentHorizontalAlignment = .right
    }
    
    func addRightIcon(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        let length = CGFloat(16) * UIScreen.ratio
        titleEdgeInsets.right += length
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 4),
            imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: length),
            imageView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
}


extension UIButton {
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration

        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
