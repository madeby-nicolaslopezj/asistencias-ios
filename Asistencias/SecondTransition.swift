//
//  SecondTransition.swift
//  Asistencias
//
//  Created by Nicolás López on 14-06-15.
//  Copyright (c) 2015 Nicolás López. All rights reserved.
//

import UIKit

class SecondTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: NSTimeInterval = 0.4
    var cornerRadius: CGFloat = 10.0
    
    var transitionMode: SecondTransitionMode = .Present
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth = screenRect.size.width;
        var screenHeight = screenRect.size.height;
        
        if transitionMode == .Present {
            
            let firstControllerView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
            let secondControllerView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
            let originalCenter = secondControllerView.center
            
            secondControllerView.layer.cornerRadius = cornerRadius;
            
            secondControllerView.frame = CGRectMake(0, 0, 540, 700)
            secondControllerView.center = CGPointMake(originalCenter.x, screenHeight * 2)
            //secondControllerView.transform = CGAffineTransformMakeScale(2, 2)
            containerView.addSubview(secondControllerView)
            
            UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
                //firstControllerView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            }, completion: nil)
            
            UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
                
                firstControllerView.center = CGPointMake(originalCenter.x, -700)
                secondControllerView.center = originalCenter
                //secondControllerView.transform = CGAffineTransformMakeScale(1, 1)
                
                }, completion: { (completed) in
                    transitionContext.completeTransition(completed)
            })
            
        } else {
            
            let secondControllerView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!.view
            let firstControllerView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!.view
            let originalCenter = secondControllerView.center
            
            UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
                firstControllerView.center = originalCenter
            }, completion: nil)
            
            UIView.animateWithDuration(duration, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
                
                //firstControllerView.transform = CGAffineTransformMakeScale(1, 1)
                firstControllerView.center = originalCenter
                //secondControllerView.transform = CGAffineTransformMakeScale(2, 2)
                secondControllerView.center = CGPointMake(originalCenter.x, screenHeight * 2)
                
                }, completion: { (completed) in
                    transitionContext.completeTransition(completed)
            })
        }
        
    }
    
    /**
    The possible directions of the transition
    */
    @objc enum SecondTransitionMode: Int {
        case Present, Dismiss
    }

}
