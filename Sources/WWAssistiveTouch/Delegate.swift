//
//  Delegate.swift
//  WWAssistiveTouch
//
//  Created by William.Weng on 2024/12/21.
//

import Foundation

// MARK: - WWAssistiveTouchDelegate
public protocol WWAssistiveTouchDelegate: AnyObject {
    
    /// AssistiveTouch是否被按下
    /// - Parameters:
    ///   - assistiveTouch: WWAssistiveTouch
    ///   - isTouched: Bool
    func assistiveTouch(_ assistiveTouch: WWAssistiveTouch, isTouched: Bool)
}
