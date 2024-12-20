//
//  WWAssistiveTouch.swift
//  WWAssistiveTouch
//
//  Created by William.Weng on 2024/12/21.
//

import UIKit
import WWPrint

// MARK: - AssistiveTouchWindow
open class WWAssistiveTouch: UIWindow {
    
    public weak var delegate: WWAssistiveTouchDelegate?
    
    private lazy var assistiveTouch = UIStoryboard(name: "Storyboard", bundle: .module).instantiateViewController(withIdentifier: "AssistiveTouch") as? AssistiveTouchViewController
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public convenience init(touchViewController: UIViewController, frame: CGRect = .init(origin: .init(x: 256, y: 256), size: .init(width: 64, height: 64)), icon: UIImage? = nil, delegate: WWAssistiveTouchDelegate? = nil) {
        self.init(frame: frame)
        self.initSetting(with: touchViewController, frame: frame, icon: icon, delegate: delegate)
    }
    
    deinit {
        delegate = nil
    }
}

// MARK: - 公開函式
public extension WWAssistiveTouch {
    
    /// [顯示AssistiveTouch的內容](https://support.apple.com/zh-tw/111794)
    /// - Parameters:
    ///   - duration: 動畫時間
    ///   - curve: 動畫曲線效果
    ///   - completion: 完成後要做的動作
    func display(with duration: TimeInterval = 0.25, curve: UIView.AnimationCurve = .easeInOut, completion: (() -> Void)? = nil) {
        assistiveTouch?.containerViewAnimation(isDisplay: true, duration: duration, curve: curve, completion: completion)
    }
    
    /// [隱藏AssistiveTouch的內容](https://mrmad.com.tw/ios-13-assistive-touch)
    /// - Parameters:
    ///   - duration: 動畫時間
    ///   - curve: 動畫曲線效果
    ///   - completion: 完成後要做的動作
    func dismiss(with duration: TimeInterval = 0.25, curve: UIView.AnimationCurve = .easeInOut, completion: (() -> Void)? = nil) {
        assistiveTouch?.containerViewAnimation(isDisplay: false, duration: duration, curve: curve, completion: completion)
    }
}

// MARK: - 小工具
private extension WWAssistiveTouch {
    
    /// 初始化設定
    /// - Parameters:
    ///   - touchViewController: UIViewController
    ///   - frame: CGRect
    func initSetting(with touchViewController: UIViewController, frame: CGRect, icon: UIImage?, delegate: WWAssistiveTouchDelegate?) {
        
        assistiveTouch?.touchViewController = touchViewController
        assistiveTouch?.touchViewFrame = frame
        assistiveTouch?.delegate = delegate
        assistiveTouch?.icon = icon

        if #available(iOS 13.0, *) { windowScene = UIWindowScene._current }
        
        self._backgroundColor(.clear)
            ._windowLevel(.alert)
            ._rootViewController(assistiveTouch)
            ._makeKeyAndVisible()
    }
}
