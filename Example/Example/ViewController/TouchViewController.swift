//
//  TouchViewController.swift
//  Example
//
//  Created by William.Weng on 2024/12/21.
//

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
