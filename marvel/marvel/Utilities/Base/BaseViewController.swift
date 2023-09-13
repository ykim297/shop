//
//  BaseViewController.swift
//  waterFlower
//
//  Created by Young Kim 2023/09/10.
//

import UIKit
import RxCocoa
import RxSwift
import RxRelay
import SnapKit

enum DeviceDirection: Int {
    case portrait = 0
    case portraitUD = 1
    case landscapeLeft = 2
    case landscapeRight = 3
    case unknown = 4
}

class BaseViewController: UIViewController {
    let screenWidth = UIScreen.width
    let screenHeight = UIScreen.height
    var keyboardHeight: CGFloat = 0.0
    let ratio = UIScreen.ratio
    var isForeground = true
    var deviceDirection: DeviceDirection = .portrait
    var disposedBag = DisposeBag()
    
    
    // Check ViewLoaded
    var isFirstLoad: Bool = true
    
    // Set Landscape value - default is false
    var isLandscape: Bool = false
    
    // Get Tabbar if it is
    var tabBar: UITabBar? {
        get {
            if let tabBar = self.navigationController?.tabBarController?.tabBar {
                return tabBar
            }
            return nil
        }
        set {}
    }
    
    lazy var indicatorView: UIView = {
        let baseView = UIView()
        baseView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.view.addSubview(baseView)
        baseView.snp.makeConstraints { [weak self] v in
            guard let self = self else { return }
            v.top.bottom.left.right.equalTo(self.view)
        }
        
        if #available(iOS 13.0, *) {
            let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
            indicator.tag = 777
            indicator.color = .darkGray
            baseView.addSubview(indicator)
            indicator.snp.makeConstraints { [weak self] v in
                guard let self = self else { return }
                v.center.equalTo(self.view)
            }

        } else {
            // Fallback on earlier versions
            let indicator = UIActivityIndicatorView(style: .whiteLarge)
            indicator.tag = 777
            indicator.color = .darkGray
            baseView.addSubview(indicator)
            indicator.snp.makeConstraints { [weak self] v in
                guard let self = self else { return }
                v.center.equalTo(self.view)
            }

        }
        baseView.setLayerBorder()
        return baseView
    }()
    
    var rxKeyboard = PublishSubject<Bool>()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFirstLoad = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillClose),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
            NetworkManager.cancellAll()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeView(_:)))
        gesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(gesture)
        gesture.delegate = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterForeground(noti:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterForeground(noti:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterBackground(noti:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterBackground(noti:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged(noti:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: UIDevice.current)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    // MARK: - Templet Method
    internal func initVariable() {
    }
    
    internal func setupLayout() {
    }
    
    internal func tabBarHidden(_ isHidden: Bool) {
        if let tabBar = self.tabBar {
            tabBar.isHidden = isHidden
            extendedLayoutIncludesOpaqueBars = isHidden
        }
    }
    
    func setComponent() {
        
    }
    
    func setAutolayOut() {
        
    }
    
    func bindViewModel(to viewModel: BaseViewModel) {
        
    }
}


extension BaseViewController {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            var keyboardHeight: CGFloat = 0.0
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardRectangle.height - view.safeAreaInsets.bottom
            } else {
                // Fallback on earlier versions
                keyboardHeight = keyboardRectangle.height
            }
            self.keyboardHeight = -keyboardHeight
            self.rxKeyboard.onNext(true)
            updateViewConstraints()
        }
    }

    @objc func keyboardWillClose(_ notification: Notification) {
        keyboardHeight = 0.0
        self.rxKeyboard.onNext(false)
        updateViewConstraints()
        view.endEditing(true)
    }

    func dismissController() {
        if let nv = self.navigationController {
         
            nv.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Notification
    @objc internal func enterForeground(noti: NSNotification) {
        self.isForeground = true
    }
    
    @objc internal func enterBackground(noti: NSNotification) {
        self.isForeground = false
    }
    
    @objc internal func orientationChanged(noti: NSNotification) {
        switch UIDevice.current.orientation {                        
        case .unknown:
            deviceDirection = .unknown
            break
        case .portrait:
            deviceDirection = .portrait
            break
        case .portraitUpsideDown:
            deviceDirection = .portraitUD
            break
        case .landscapeLeft:
            deviceDirection = .landscapeLeft
            break
        case .landscapeRight:
            deviceDirection = .landscapeRight
            break
        case .faceUp:
            deviceDirection = .unknown
            break
        case .faceDown:
            deviceDirection = .unknown
            break
        @unknown default:
            deviceDirection = .unknown
            break
        }
    }
    
    func changeStatusBarBgColor(bgColor: UIColor?) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let statusBarManager = window?.windowScene?.statusBarManager
            
            let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
            statusBarView.backgroundColor = bgColor
            
            window?.addSubview(statusBarView)
        } else {
            let statusBarView = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBarView?.backgroundColor = bgColor
        }
    }
    
    func updateOrientation(orientation: UIInterfaceOrientationMask) {
        if #available(iOS 16, *) {
            DispatchQueue.main.async {
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
                self.navigationController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: orientation)) { error in
                    Log.message(to: error)
                    Log.message(to: windowScene?.effectiveGeometry ?? "")
                }
            }
        }
        else {
            switch orientation {
            case .portrait, .portraitUpsideDown:
                let value = UIDeviceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                break
            case .landscapeLeft:
                let value = UIDeviceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                break
            case .landscapeRight:
                let value = UIDeviceOrientation.landscapeLeft.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
            default:
                break
            }
        }
    }
    
    @discardableResult func onRotate() -> Bool{
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .unknown, .portrait, .portraitUpsideDown, .faceUp, .faceDown:
            Orientation.lockOrientation(.landscapeRight)
            updateOrientation(orientation: .landscapeRight)
            deviceDirection = .landscapeRight
            break
        case .landscapeLeft, .landscapeRight:
            Orientation.lockOrientation(.portrait)
            updateOrientation(orientation: .portrait)
            deviceDirection = .portrait
            break
        default:
            deviceDirection = .unknown
            break
        }
        
        return deviceDirection == .landscapeRight ? true : false
    }
    
    public func showMessageAlert(message: String, title: String, actions:[UIAlertAction]? = nil) {
        let controller = UIAlertController.init(title: title ,
                                                message: message ,
                                                preferredStyle: UIAlertController.Style.alert)
        if let acts = actions {
            for action in acts {
                controller.addAction(action)
            }
        } else {
            let action = UIAlertAction.init(title: "CLOSE", style: UIAlertAction.Style.default) {(action) in }
            controller.addAction(action)
        }
        
        if let vc = UIApplication.topViewController() {
            DispatchQueue.main.async {
                vc.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func showIndicator() {
        DispatchQueue.main.async {
            self.indicatorView.isHidden = false
            self.view.bringSubviewToFront(self.indicatorView)
            if let i: UIActivityIndicatorView = self.indicatorView.viewWithTag(777) as? UIActivityIndicatorView {
                i.startAnimating()
                let delay = 10
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                    self.closeIndicator()
                }
            }
        }
    }

    func closeIndicator() {
        DispatchQueue.main.async {
            self.indicatorView.isHidden = true
            if let i: UIActivityIndicatorView = self.indicatorView.viewWithTag(777) as? UIActivityIndicatorView {
                i.stopAnimating()
            }
        }
    }
    
    func verticallyClose(_ animated: Bool = true) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .reveal
        transition.subtype = .fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: animated)
    }
    
    func horizontallyclose(_ animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func setTabbar(isShow: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = !isShow
        
        if !isShow {
            edgesForExtendedLayout = UIRectEdge.bottom
            extendedLayoutIncludesOpaqueBars = true
        }
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    
    @objc func closeView(_ gesture: UITapGestureRecognizer) {
        keyboardHeight = 0.0
        updateViewConstraints()
        view.endEditing(true)
    }
    
    func getRelativeContraintValue(_ constant: CGFloat, guide: CGFloat = 414.0) -> CGFloat {
        let width = UIScreen.width
        let value =  (constant / guide) * width
        return value
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if touch.view is UIButton {
//            return false
//        }
        return true
    }

}




