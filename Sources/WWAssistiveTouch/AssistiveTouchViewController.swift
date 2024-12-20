//
//  AssistiveTouchViewController.swift
//  WWAssistiveTouch
//
//  Created by William.Weng on 2024/12/21.
//

import UIKit

// MARK: - 內容ViewController
final class AssistiveTouchViewController: UIViewController {
    
    @IBOutlet weak var touchImageView: UIImageView!
    @IBOutlet weak var touchContainerView: UIView!
    
    weak var delegate: WWAssistiveTouchDelegate?
    
    var touchViewController: UIViewController?
    var touchViewFrame: CGRect = .zero
    var icon: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let window = view.window { automoveCenterAction(window) }
    }
    
    deinit {
        delegate = nil
    }
}

// MARK: - @objc
@objc extension AssistiveTouchViewController {
    
    /// 拖曳移動Window (歸零)
    /// - Parameter pan: UIPanGestureRecognizer
    func handleDrag(_ pan: UIPanGestureRecognizer) {
        
        guard let window = view.window else { return }
        
        switch pan.state {
        case .began, .changed: moveCenterAction(window, pan: pan)
        case .ended: automoveCenterAction(window)
        case .cancelled, .possible, .failed: break
        @unknown default: break
        }
    }
    
    /// 點擊後功能處理
    /// - Parameter tap: UITapGestureRecognizer
    func handleTap(_ tap: UITapGestureRecognizer) {
        
        guard let assistiveTouch = view.window as? WWAssistiveTouch,
              let delegate = delegate
        else {
            containerViewAnimation(isDisplay: true, duration: 0.25, curve: .easeInOut)
            return
        }
        
        delegate.assistiveTouch(assistiveTouch, isTouched: true)
    }
}

// MARK: 公用工具
extension AssistiveTouchViewController {
    
    /// 顯示內容畫面的動作處理
    /// - Parameters:
    ///   - isDisplay: Bool
    ///   - duration: TimeInterval
    ///   - curve: UIView.AnimationCurve
    func containerViewAnimation(isDisplay: Bool, duration: TimeInterval, curve: UIView.AnimationCurve) {
        
        guard let window = view.window as? WWAssistiveTouch else { return }
        
        var windowFrame = touchViewFrame
        
        !isDisplay ? delegate?.assistiveTouch(window, status: .display) : delegate?.assistiveTouch(window, status: .dismiss)
        if isDisplay { touchViewFrame = window.frame; windowFrame = UIScreen.main.bounds }
        displayTouchContainerView(!isDisplay)
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) { [unowned self] in
            window.frame = windowFrame
            delegate?.assistiveTouch(window, status: .animation)
            displayTouchContainerView(isDisplay)
        }
        
        animator.addCompletion { [unowned self] _ in isDisplay ? delegate?.assistiveTouch(window, status: .display) : delegate?.assistiveTouch(window, status: .dismiss) }
        animator.startAnimation()
    }
}

// MARK: - 小工具
private extension AssistiveTouchViewController {
        
    /// 初始化設定
    func initSetting() {
        initGestureSetting()
        initTouchViewControllerSetting()
    }
    
    /// [初始化觸碰設定](https://look.s3.com.tw/look/living/ss4gw0/page/21458)
    func initGestureSetting() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let drag = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        
        if let icon = icon { touchImageView.image = icon }
        
        touchImageView.isUserInteractionEnabled = true
        touchImageView.addGestureRecognizer(tap)
        touchImageView.addGestureRecognizer(drag)
    }
    
    /// 初始化內容ViewController的設定
    func initTouchViewControllerSetting() {
        
        guard let touchViewController = touchViewController else { return }
        
        _changeContainerView(at: touchContainerView, to: touchViewController)
        displayTouchContainerView(false)
    }
    
    /// 拖曳移動中點
    /// - Parameters:
    ///   - window: UIWindow
    ///   - pan: UIPanGestureRecognizer
    func moveCenterAction(_ window: UIWindow, pan: UIPanGestureRecognizer) {
        window.center = moveCenter(window, pan: pan)
        pan.setTranslation(.zero, in: pan.view)
    }
    
    /// 自動移動中點的位置到邊上
    /// - Parameter window: UIWindow
    func automoveCenterAction(_ window: UIWindow) {
        
        UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.5) { [unowned self] in
            window.center = automoveCenter(with: window)
        }.startAnimation()
    }
    
    /// 設定Window的中點位置 => 不能超出畫面範圍
    /// - Parameters:
    ///   - window: UIWindow
    ///   - pan: UIPanGestureRecognizer
    /// - Returns: CGPoint
    func moveCenter(_ window: UIWindow, pan: UIPanGestureRecognizer) -> CGPoint {
        
        let screenBounds = UIScreen.main.bounds
        let touchImageCenter = touchImageView.center
        let panLocation = pan.translation(in: pan.view)
        
        var center = CGPoint(x: window.center.x + panLocation.x, y: window.center.y + panLocation.y)
        
        if (center.x < touchImageCenter.x) { center.x = touchImageCenter.x }
        if (center.y < touchImageCenter.y) { center.y = touchImageCenter.y }
        if (center.x > screenBounds.width - touchImageCenter.x) { center.x = screenBounds.width - touchImageCenter.x }
        if (center.y > screenBounds.height - touchImageCenter.y) { center.y = screenBounds.height - touchImageCenter.y }
        
        return center
    }
    
    /// 自動設定Window的中點位置 => 貼在左右畫面的邊上
    /// - Parameter window: UIWindow
    /// - Returns: CGPoint
    func automoveCenter(with window: UIWindow) -> CGPoint {
        
        let center = window.center
        let screenBounds = UIScreen.main.bounds
        let screenCenter = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        let touchImageCenter = touchImageView.center
        
        if (center.x < screenCenter.x) { return .init(x: touchImageCenter.x, y: center.y) }
        return .init(x: screenBounds.width - touchImageCenter.x , y: center.y)
    }
    
    /// 設定要不要顯示內容畫面
    /// - Parameter isDisplay: Bool
    func displayTouchContainerView(_ isDisplay: Bool) {
        
        touchContainerView.alpha = isDisplay ? 1.0 : 0.0
        touchImageView.alpha = !isDisplay ? 1.0 : 0.0
    }
}
