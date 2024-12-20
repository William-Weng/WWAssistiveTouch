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
    var assistiveTouch: WWAssistiveTouch!
    
    private lazy var touchViewController = { UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Touch") }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        assistiveTouch = WWAssistiveTouch(touchViewController: touchViewController, icon: UIImage(named: "Rec"), delegate: self)
        return true
    }
}

// MARK: - WWAssistiveTouchDelegate
extension AppDelegate: WWAssistiveTouchDelegate {
    
    func assistiveTouch(_ assistiveTouch: WWAssistiveTouch, isTouched: Bool) {
        if (isTouched) { assistiveTouch.display() }
    }
    
    func assistiveTouch(_ assistiveTouch: WWAssistiveTouch, status: WWAssistiveTouch.Status) {
        print(status)
    }
}
