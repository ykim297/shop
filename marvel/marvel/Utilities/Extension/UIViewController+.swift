//
//  UIViewController+.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit

extension UIViewController {
    var hasTopNotch: Bool {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }

    var rootViewController: UIViewController? {
        
        var presentedVC = UIWindow.key?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }

        if presentedVC == nil {}
        return presentedVC
    }

    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
//    var sceneDelegate: SceneDelegate {
//        return UIApplication.shared.connectedScenes
//            .first!.delegate as! SceneDelegate
//    }
    
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = style == .lightContent ? UIColor.black : .white
            statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
        }
    }

    func setClearBarStye(_ style: Bool = false) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = style == true ? UIColor.clear : UIColor.white
            statusBar.setValue(style == true ? UIColor.black : UIColor.black, forKey: "foregroundColor")
        }
    }

    func setBlackStyle(_ style: Bool) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = style == true ? UIColor.white : UIColor.clear
            statusBar.setValue(style == true ? UIColor.black : UIColor.white, forKey: "foregroundColor")
        }
    }

    func alertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    func alertView(title: String, message: String, action:[UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for i in action {
            alert.addAction(i)
        }
        present(alert, animated: true, completion: nil)
    }
    
//    func getCurrentViewController() -> UIViewController? {
//        let keyWindow = UIApplication.shared.connectedScenes
//                .filter({$0.activationState == .foregroundActive})
//                .map({$0 as? UIWindowScene})
//                .compactMap({$0})
//                .first?.windows
//                .filter({$0.isKeyWindow}).first
//
//        if let rootController = keyWindow?.rootViewController {
//            var currentController: UIViewController! = rootController
//            while currentController.presentedViewController != nil {
//                currentController = currentController.presentedViewController
//            }
//            return currentController
//        }
//        return nil
//    }
    
//    func showToast(duration: Double = 2.0,
//                   message : String,
//                   font: UIFont = .systemFont(ofSize: 13.0), title: String? = nil) {
//        let ratio = UIScreen.ratio
//        let x = 12.0
//        let minus: CGFloat = title == nil ? 40.0 : 0.0
//        let y = UIScreen.height - 160.0 - UIApplication.shared.safeAreaBottom - UIApplication.shared.statusBarHeight + minus
//        let width = UIScreen.width - 24.0
//        let view = UIView(frame: CGRect(x: CGFloat(x),
//                                        y: y,
//                                        width: width,
//                                        height: title == nil ? 87.0 : 117.0))
//        view.alpha = 1.0
//        view.backgroundColor = .white
//        view.roundCorners(.allCorners, radius: 4.0 * ratio)
//        self.view.addSubview(view)
//        
//        let label = UILabel()
//        label.textColor = .black
//        label.font = font
//        label.textAlignment = .left;
//        label.text = message
//        label.numberOfLines = 3
//        view.addSubview(label)
//        label.setLayerBorder()
//        
//        label.snp.makeConstraints { v in
//            v.top.equalTo(view.snp.top).offset(14.0)
//            v.left.equalTo(view.snp.left).offset(20.0)
//            v.height.equalTo(60.0)
//        }
//        
//        
//        if let t = title {
//            let bottom = UILabel()
//            bottom.textColor = .black
//            bottom.font = .systemFont(ofSize: 14.0)
//            bottom.textAlignment = .left;
//            bottom.text = t
//            view.addSubview(bottom)
//            bottom.setLayerBorder()
//
//            bottom.snp.makeConstraints { v in
//                v.top.equalTo(label.snp.bottom).offset(10.0)
//                v.left.equalTo(view.snp.left).offset(20.0)
//                v.height.equalTo(20.0)
//            }
//
//        }
//        
//        
//        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut,
//                       animations: { view.alpha = 0.0 },
//                       completion: {(isCompleted) in
//                        view.removeFromSuperview()
//                       })
//        
//    }
    

}

extension UIViewController {
    func addChildController(_ childController: UIViewController) {
        addChild(childController)
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
    }

    func removeChildController(_ childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }
}
