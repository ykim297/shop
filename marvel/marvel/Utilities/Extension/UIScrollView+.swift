//
//  UIScrollView+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit



extension UIScrollView {
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            
            let bottomOffset = scrollBottomOffset()
            if (childStartPoint.y > bottomOffset.y) {
                setContentOffset(bottomOffset, animated: true)
            } else {
                setContentOffset(CGPoint(x: 0, y: childStartPoint.y), animated: true)
            }
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: true)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = scrollBottomOffset()
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
    private func scrollBottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
    }
    
    func contentOffsetCompletion(time:CGFloat = 0.0, x: CGFloat, y: CGFloat, complete: @escaping(() -> Void)) {
        UIView.animate(withDuration:time, delay: 0, options: .curveEaseInOut) {
            self.setContentOffset(CGPointMake(x, y), animated: false)
        } completion: { finished in
            if finished {
                complete()
            }
        }
    }
    
    
}
