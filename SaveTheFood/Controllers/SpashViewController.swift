//
//  ViewController.swift
//  SaveTheFood
//
//  Created by Andrea Franco on 2020-05-26.
//  Copyright © 2020 Andrea Franco. All rights reserved.
//

import UIKit

class SpashViewController: UIViewController, CAAnimationDelegate {
    @IBOutlet var screenImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = 3
        pulseAnimation.delegate = self
        screenImage.layer.add(pulseAnimation, forKey: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.performSegue(withIdentifier: K.splashSegue, sender: self)
    }

}

