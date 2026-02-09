# WWAssistiveTouch

[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-15.0](https://img.shields.io/badge/iOS-15.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![](https://img.shields.io/github/v/tag/William-Weng/WWAssistiveTouch) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

## [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- Mimicking iPhone’s Assistive Touch function.
- 模仿iPhone手機的Assistive Touch功能

https://github.com/user-attachments/assets/71e5a8a9-508c-4210-923a-3ead806d3d42

## [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```bash
dependencies: [
    .package(url: "https://github.com/William-Weng/WWAssistiveTouch.git", .upToNextMajor(from: "1.2.2"))
]
```

## [可用函式](https://ezgif.com/video-to-webp)
|函式|說明|
|-|-|
|init(touchViewController:frame:size:gap:icon:isAutoAdjust:delegate:)|初始化AssistiveTouch|
|display(with:curve:)|顯示AssistiveTouch的內容|
|dismiss(with:curve:)|隱藏AssistiveTouch的內容|
|adjust()|自動校正中點位置|
|setTouchViewController(_:)|設定要顯示的ViewController|

## WWAssistiveTouchDelegate
|函式|說明|
|-|-|
|assistiveTouch(_:isTouched:)|AssistiveTouch是否被按下|
|assistiveTouch(_:status:)|AssistiveTouch的顯示狀態|

## Example
```swift
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

extension AppDelegate: WWAssistiveTouch.Delegate {
    
    func assistiveTouch(_ assistiveTouch: WWAssistiveTouch, isTouched: Bool) {
        if (isTouched) { assistiveTouch.display() }
    }
    
    func assistiveTouch(_ assistiveTouch: WWAssistiveTouch, status: WWAssistiveTouch.Status) {
        print(status)
    }
}
```
```swift
import UIKit
import WWAssistiveTouch

final class TouchViewController: UIViewController {
    
    var assistiveTouch: WWAssistiveTouch?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.alpha = 0.5
        
        UIViewPropertyAnimator(duration: 0.25, curve: .linear) { [unowned self] in
            view.alpha = 1.0
        }.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.alpha = 0.0
    }
    
    @IBAction func dismissTouchView(_ sender: UIButton) {
        assistiveTouch?.dismiss()
    }
    
    deinit {
        assistiveTouch = nil
    }
}
```
