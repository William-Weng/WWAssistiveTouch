//
//  AppDelegate.swift
//  Example
//
//  Created by William.Weng on 2024/12/21.
//

import UIKit
import WWAssistiveTouch

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private lazy var touchViewController = { UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Touch") as! TouchViewController }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let assistiveTouch = WWAssistiveTouch(touchViewController: touchViewController, icon: UIImage(named: "Rec"), isAutoAdjust: true, delegate: self)
        touchViewController.assistiveTouch = assistiveTouch
        return true
    }
}

// MARK: - WWAssistiveTouch.Delegate
extension AppDelegate: WWAssistiveTouch.Delegate {
    
    func assistiveTouch(_ assistiveTouch: WWAssistiveTouch, isTouched: Bool) {
        if (isTouched) { assistiveTouch.display() }
    }
    
    func assistiveTouch(_ assistiveTouch: WWAssistiveTouch, status: WWAssistiveTouch.Status) {
        print(status)
    }
}
