//
//  MainTransition.swift
//  Asistencias
//
//  Created by Nicolás López on 14-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import UIKit

class MainTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration = 0.5
    var cornerRadius: CGFloat = 10.0
    
    var transitionMode: MainTransitionMode = .Present
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth = screenRect.size.width;
        var screenHeight = screenRect.size.height;
        
        if transitionMode == .Present {
            
            let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            let originalCenter = presentedControllerView.center
            let originalSize = presentedControllerView.frame.size
            
            presentedControllerView.layer.cornerRadius = cornerRadius;
            presentedControllerView.frame = CGRectMake(0, 0, 400, 700)
            presentedControllerView.center = CGPointMake(originalCenter.x, -700);
            presentedControllerView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            containerView.addSubview(presentedControllerView)
            
            UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
                presentedControllerView.center = originalCenter
            }, completion: nil)
            
            UIView.animateWithDuration(duration, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
        
                presentedControllerView.transform = CGAffineTransformMakeScale(1, 1)
                
                }, completion: { (completed) in
                    transitionContext.completeTransition(completed)
            })

        } else {
            println("Dismiss!")
            transitionContext.completeTransition(true)
        }
        
    }
    
    /**
    The possible directions of the transition
    */
    @objc enum MainTransitionMode: Int {
        case Present, Dismiss
    }

}
