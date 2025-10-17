//
//  Delegate.swift
//  WWAssistiveTouch
//
//  Created by William.Weng on 2024/12/21.
//

import Foundation

// MARK: - WWAssistiveTouch.Delegate
public extension WWAssistiveTouch {
    
    public protocol Delegate: AnyObject {
        
        /// AssistiveTouch是否被按下
        /// - Parameters:
        ///   - assistiveTouch: WWAssistiveTouch
        ///   - isTouched: Bool
        func assistiveTouch(_ assistiveTouch: WWAssistiveTouch, isTouched: Bool)
        
        /// AssistiveTouch的顯示狀態
        /// - Parameters:
        ///   - assistiveTouch: WWAssistiveTouch
        ///   - status: WWAssistiveTouch.Status
        func assistiveTouch(_ assistiveTouch: WWAssistiveTouch, status: WWAssistiveTouch.Status)
    }
}
