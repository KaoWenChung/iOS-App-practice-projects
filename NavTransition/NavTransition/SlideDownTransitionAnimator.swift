//
//  SlideDownTransitionAnimator.swift
//  NavTransition
//
//  Created by wyn on 2020/5/17.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation
import UIKit

class SlideDownTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, soucre: UIViewController) -> UIViewControllerAnimatedTransitioning {
        
        return self
    }
    
    func animationController(forDismiss dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self
    }
    
    let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Get fromView, toView and container view's reference
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        // Set transform we used from animation
        let container = transitionContext.containerView
        
        let offScreenUp = CGAffineTransform(translationX: 0, y: -container.frame.height)
        let offScreenDown = CGAffineTransform(translationX: 0, y: container.frame.height)
        
        // Let toView leave screen
        toView.transform = offScreenUp
        
        // Add two screen into container view
        container.addSubview(fromView)
        container.addSubview(toView)
        
        // Run animation
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            fromView.transform = offScreenDown
            fromView.alpha = 0.5
            toView.transform = CGAffineTransform.identity
            toView.alpha = 1.0
            
        }, completion: { finished in
            
            transitionContext.completeTransition(true)
        })
    }
}
