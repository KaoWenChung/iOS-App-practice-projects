//
//  LoginViewController.swift
//  VisualEffect
//
//  Created by Simon Ng on 24/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    private let imageSet = ["cloud", "coffee", "food", "pmq", "temple"]
    private var blurEffectView: UIVisualEffectView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Random a photo to pick out
        let selectedImageIndex = Int(arc4random_uniform(5))
        
        // Generate visual blur effect
        backgroundImageView.image = UIImage(named: imageSet[selectedImageIndex])
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        blurEffectView?.frame = view.bounds
    }

}
