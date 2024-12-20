//
//  TouchViewController.swift
//  Example
//
//  Created by William.Weng on 2024/12/21.
//

import UIKit

final class TouchViewController: UIViewController {
    
    @IBAction func dismissTouchView(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.assistiveTouch.dismiss()
    }
}
