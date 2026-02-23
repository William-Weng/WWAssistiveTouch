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
    
    weak var delegate: WWAssistiveTouch.Delegate?
    
    var isAutoAdjust = false
    var isDisplay = false
    var touchViewFrame: CGRect = .zero
    var icon: UIImage?
    var gap: CGFloat = 5.0
    var touchViewController: UIViewController?

    private var effectViewController: UIViewController?
    private var previousCenter: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let window = view.window { automoveCenterAction(window, gap: gap) }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if isAutoAdjust { viewWillTransitionAction(to: size, with: coordinator, gap: gap) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.effectViewController = segue.destination
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
        case .ended: automoveCenterAction(window, gap: gap)
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
            containerViewAnimation(isDisplay: true, duration: 0.25, curve: .easeInOut); return
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
        
        self.isDisplay = isDisplay
        
        !isDisplay ? delegate?.assistiveTouch(window, status: .display) : delegate?.assistiveTouch(window, status: .dismiss)
        if isDisplay { touchViewFrame = window.frame; windowFrame = UIScreen.main.bounds }
        
        displayTouchContainerView(!isDisplay)
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) { [unowned self] in
            
            if !isDisplay { changeContainerView(with: isDisplay) }
            
            window.frame = windowFrame
            delegate?.assistiveTouch(window, status: .animation)
            displayTouchContainerView(isDisplay)
        }
        
        animator.addCompletion { [unowned self] _ in
            
            if (isDisplay) {
                changeContainerView(with: isDisplay)
                delegate?.assistiveTouch(window, status: .display)
            } else {
                automoveCenterAction(window, gap: gap)
                delegate?.assistiveTouch(window, status: .dismiss)
            }
        }
        
        animator.startAnimation()
    }
    
    /// 校正中點位置
    /// - Parameters:
    ///   - window: UIWindow
    ///   - gap: CGFloat
    func adjust(window: UIWindow, gap: CGFloat) {
        window.center = previousCenter
        window.alpha = 1.0
        automoveCenterAction(window, gap: gap)
    }
    
    /// 自動校正中點位置
    /// - Parameters:
    ///   - size: CGSize
    ///   - coordinator: UIViewControllerTransitionCoordinator
    ///   - gap: CGFloat
    func autoAdjust(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator, gap: CGFloat) {
        
        guard let window = view.window else { return }
        
        window.alpha = 0.0
                
        coordinator.animate { context in
            window.alpha = 0.0
        } completion: { [self] context in
            adjust(window: window, gap: gap)
        }
    }
}

// MARK: - 小工具
private extension AssistiveTouchViewController {
    
    /// 初始化設定
    func initSetting() {
        previousCenter = touchViewFrame.origin
        initGestureSetting()
        displayTouchContainerView(false)
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
    
    /// 拖曳移動中點
    /// - Parameters:
    ///   - window: UIWindow
    ///   - pan: UIPanGestureRecognizer
    func moveCenterAction(_ window: UIWindow, pan: UIPanGestureRecognizer) {
        window.center = moveCenter(window, pan: pan)
        pan.setTranslation(.zero, in: pan.view)
    }
    
    /// 自動修正中心位置 (如果顯示的話就沒有gap => 滿版)
    /// - Parameters:
    ///   - size: CGSize
    ///   - coordinator: UIViewControllerTransitionCoordinator
    ///   - gap: CGFloat
    func viewWillTransitionAction(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator, gap: CGFloat) {
        if (isDisplay) { return }
        autoAdjust(to: size, with: coordinator, gap: gap)
    }
    
    /// 自動移動中點的位置到邊上 (如果顯示中就沒有動畫)
    /// - Parameters:
    ///   - window: UIWindow
    ///   - gap: CGFloat
    func automoveCenterAction(_ window: UIWindow, gap: CGFloat) {
        
        previousCenter = window.center
        
        if (isDisplay) { window.center = automoveCenter(with: window, gap: 0); return }
        
        UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.5) { [unowned self] in
            window.center = automoveCenter(with: window, gap: gap)
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
    /// - Parameters:
    ///   - window: UIWindow
    ///   - gap: 與邊框的間隔
    /// - Returns: CGPoint
    func automoveCenter(with window: UIWindow, gap: CGFloat) -> CGPoint {
        
        let windowCenter = window.center
        let screenBounds = UIScreen.main.bounds
        let screenCenter = CGPoint(x: screenBounds.width * 0.5, y: screenBounds.height * 0.5)
        let touchImageCenter = touchImageView.center
        
        var center = windowCenter
        center.x = (windowCenter.x < screenCenter.x) ? touchImageCenter.x + gap : screenBounds.width - touchImageCenter.x - gap
        
        if (center.y <= touchImageCenter.y) { center.y = touchImageCenter.y + gap }
        if (center.y >= screenBounds.height - touchImageCenter.y) { center.y = screenBounds.height - touchImageCenter.y - gap }
        
        return center
    }
    
    /// 根據是否顯示來決定ContainerView
    /// - Parameter isDisplay: Bool
    func changeContainerView(with isDisplay: Bool) {
        
        guard let touchViewController = touchViewController,
              let effectViewController = effectViewController
        else {
            return
        }
        
        if isDisplay { _changeContainerView(at: touchContainerView, from: effectViewController, to: touchViewController); return }
        _changeContainerView(at: touchContainerView, from: touchViewController, to: effectViewController)
    }
    
    /// 設定要不要顯示內容畫面
    /// - Parameter isDisplay: Bool
    func displayTouchContainerView(_ isDisplay: Bool) {
        
        touchContainerView.alpha = isDisplay ? 1.0 : 0.0
        touchImageView.alpha = !isDisplay ? 1.0 : 0.0
    }
}
