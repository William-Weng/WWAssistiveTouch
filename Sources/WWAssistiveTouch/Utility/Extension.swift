//
//  Extension.swift
//  WWAssistiveTouch
//
//  Created by William.Weng on 2024/12/21.
//

import UIKit

// MARK: - UIStoryboard (static function)
extension UIStoryboard {
    
    /// 由UIStoryboard => ViewController
    /// - Parameters:
    ///   - name: Storyboard的名稱 => Main.storyboard
    ///   - storyboardBundleOrNil: Bundle名稱
    ///   - identifier: ViewController的代號 (記得要寫)
    /// - Returns: T (泛型) => UIViewController
    static func _instantiateViewController<T: UIViewController>(name: String = "Main", bundle storyboardBundleOrNil: Bundle? = nil, identifier: String = String(describing: T.self)) -> T {
        
        let viewController: T
        
        if #available(iOS 13.0, *) {
            viewController = Self(name: name, bundle: storyboardBundleOrNil).instantiateViewController(identifier: identifier) as T
        } else {
            viewController = Self(name: name, bundle: storyboardBundleOrNil).instantiateViewController(withIdentifier: identifier) as! T
        }
        
        return viewController
    }
}

// MARK: - UIWindow (function)
extension UIWindow {
    
    /// 設定背景色
    /// - Parameter color: UIColor?
    /// - Returns: Self
    func _backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }
    
    /// 設定前後關係的Level
    /// - Parameter level: UIWindow.Level
    /// - Returns: Self
    func _windowLevel(_ level: UIWindow.Level) -> Self {
        self.windowLevel = level
        return self
    }
    
    /// 設定rootViewController
    /// - Parameter rootViewController: UIViewController
    /// - Returns: Self
    func _rootViewController(_ rootViewController: UIViewController?) -> Self {
        self.rootViewController = rootViewController
        return self
    }
    
    /// 設定成主要的，並且顯示出來
    func _makeKeyAndVisible() {
        self.makeKeyAndVisible()
    }
}

// MARK: - UIWindowScene (static function)
extension UIWindowScene {
    static var _current: UIWindowScene? { return UIApplication.shared.connectedScenes.first as? UIWindowScene }
}

// MARK: - UIWindowScene (function)
extension UIViewController {
    
    /// [改變ContainerView](https://disp.cc/b/11-9XMd)
    /// - Parameters:
    ///   - containerView: UIView
    ///   - oldViewController: 舊的ViewController
    ///   - newViewController: 新的ViewController
    func _changeContainerView(at containerView: UIView, from oldViewController: UIViewController? = nil, to newViewController: UIViewController) {
        
        oldViewController?.willMove(toParent: self)
        oldViewController?.view.removeFromSuperview()
        oldViewController?.removeFromParent()
        
        addChild(newViewController)
        newViewController.view._autolayout(on: containerView)
        newViewController.didMove(toParent: self)
    }
}

// MARK: - UIView (function)
extension UIView {
    
    /// [設定LayoutConstraint => 不能加frame](https://zonble.gitbooks.io/kkbox-ios-dev/content/autolayout/intrinsic_content_size.html)
    /// - Parameter view: [要設定的View](https://www.appcoda.com.tw/auto-layout-programmatically/)
    func _autolayout(on view: UIView) {

        removeFromSuperview()
        view.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
