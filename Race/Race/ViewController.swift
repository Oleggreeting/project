//
//  ViewController.swift
//  Race
//
//  Created by Oleg on 5/4/20.
//  Copyright © 2020 Oleg. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
var motionManager = CMMotionManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        addParallaxToView(view: imageView, magnitude: 20)
    }
 
    @IBAction func buttonGo(_ sender: UIButton) {
        let VC = storyboard?.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
        navigationController?.pushViewController(VC, animated: true)
    }
    func addParallaxToView(view: UIView, magnitude: Float) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -magnitude
        horizontal.maximumRelativeValue = magnitude

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -magnitude
        vertical.maximumRelativeValue = magnitude

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
    }
}

