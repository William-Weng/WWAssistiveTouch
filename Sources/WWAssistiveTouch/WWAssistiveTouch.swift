//
//  WWAssistiveTouch.swift
//  WWAssistiveTouch
//
//  Created by William.Weng on 2024/12/21.
//

import UIKit

// MARK: - AssistiveTouchWindow
open class WWAssistiveTouch: UIWindow {
    
    /// 動作狀態
    public enum Status {
        case display    // 顯示
        case animation  // 動畫中
        case dismiss    // 隱藏
    }
        
    private lazy var assistiveTouch = UIStoryboard(name: "Storyboard", bundle: .module).instantiateViewController(withIdentifier: "AssistiveTouch") as? AssistiveTouchViewController
    
    public convenience init(touchViewController: UIViewController, frame: CGRect = .init(origin: .init(x: 256, y: 256), size: .init(width: 64, height: 64)), icon: UIImage? = nil, delegate: WWAssistiveTouchDelegate? = nil) {
        self.init(frame: frame)
        self.initSetting(with: touchViewController, frame: frame, icon: icon, delegate: delegate)
    }
}

// MARK: - 公開函式
public extension WWAssistiveTouch {
    
    /// [顯示AssistiveTouch的內容](https://support.apple.com/zh-tw/111794)
    /// - Parameters:
    ///   - duration: 動畫時間
    ///   - curve: 動畫曲線效果
    func display(with duration: TimeInterval = 0.25, curve: UIView.AnimationCurve = .easeInOut) {
        assistiveTouch?.containerViewAnimation(isDisplay: true, duration: duration, curve: curve)
    }
    
    /// [隱藏AssistiveTouch的內容](https://mrmad.com.tw/ios-13-assistive-touch)
    /// - Parameters:
    ///   - duration: 動畫時間
    ///   - curve: 動畫曲線效果
    ///   - completion: 完成後要做的動作
    func dismiss(with duration: TimeInterval = 0.25, curve: UIView.AnimationCurve = .easeInOut) {
        assistiveTouch?.containerViewAnimation(isDisplay: false, duration: duration, curve: curve)
    }
}

// MARK: - 小工具
private extension WWAssistiveTouch {
    
    /// 初始化設定
    /// - Parameters:
    ///   - touchViewController: UIViewController
    ///   - frame: CGRect
    ///   - icon: UIImage?
    ///   - delegate: WWAssistiveTouchDelegate?
    func initSetting(with touchViewController: UIViewController, frame: CGRect, icon: UIImage?, delegate: WWAssistiveTouchDelegate?) {
        
        windowScene = UIWindowScene._current
        
        assistiveTouch?.touchViewController = touchViewController
        assistiveTouch?.touchViewFrame = frame
        assistiveTouch?.delegate = delegate
        assistiveTouch?.icon = icon
        
        self._backgroundColor(.clear)
            ._windowLevel(.alert + 1000)
            ._rootViewController(assistiveTouch)
            ._makeKeyAndVisible()
        
        delegate?.assistiveTouch(self, status: .dismiss)
    }
}
