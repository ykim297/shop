//
//  UIApplication+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit

extension UIApplication {
    // access the statusBar on an ViewController
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }

    @available(iOS 13.0, *)
    var safeAreaBottom: CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

        return keyWindow?.safeAreaInsets.bottom ?? 0
    }

    @available(iOS 13.0, *)
    var statusBarHeight: CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

        return keyWindow?.safeAreaInsets.top ?? 20
    }
    
    // find the top viewcontroller on the application
    class func topViewController(controller: UIViewController? = UIWindow.key?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    class func closePopUp(completion: @escaping(Bool) -> Void) {
        guard let vc = self.topViewController() else {
            completion(true)
            return
        }
        
//        if vc is PopUpViewController {
//            vc.dismiss(animated: true) {
//                completion(true)
//            }
//        }
    }
    
    @available(iOS 13.0, *)
    class func setStatusBar(bgColor: UIColor? = nil) {
        guard let window = UIApplication.shared.windows.first else { return }
        
//        for view in window.subviews {
//            if (view.viewWithTag(7777777) != nil) {
//                view.removeFromSuperview()
//            }
//        }
        
        if let view = window.viewWithTag(7777777) {
            view.removeFromSuperview()
        }

        if let bgColor {
            let statusBarManager = window.windowScene?.statusBarManager
            let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
            statusBarView.tag = 7777777
            statusBarView.backgroundColor = bgColor
            window.addSubview(statusBarView)
        } 
    }
    
    @available(iOS 13.0, *)
    class func changeStatusBarBgColor(bgColor: UIColor?, tag: Int = 7777777) {
        let window = UIApplication.shared.windows.first
        let statusBarManager = window?.windowScene?.statusBarManager
        
        let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
        statusBarView.tag = tag
        statusBarView.backgroundColor = bgColor
        
        window?.addSubview(statusBarView)
    }
    
    class func hiddenStatusBar(isHidden: Bool, tag: Int = 7777777) {
        guard let window = UIApplication.shared.windows.first else { return }
        if let view = window.viewWithTag(tag) {
            view.removeFromSuperview()
        }
    }
}

extension UIWindow {
    static var key: UIWindow? {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }
}


