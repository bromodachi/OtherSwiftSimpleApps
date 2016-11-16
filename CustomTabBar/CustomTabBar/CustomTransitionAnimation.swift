//
//  CustomTransitionAnimation.swift
//  CustomTabBar
//
//  Created by c.uraga on 2016/11/16.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit

class CustomTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var decideWhereToGO:Int!
    convenience init(leftOrRight: Int) {
        self.init()
        decideWhereToGO = leftOrRight
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) {
            let fromView = fromVC.view!
            let toView = toVC.view!
            
            let containerView = transitionContext.containerView
            containerView.clipsToBounds = false
            containerView.addSubview(toView)
            
    
            
            var fromViewEndFrame = fromView.frame
            if decideWhereToGO > 0 {
                fromViewEndFrame.origin.x = containerView.frame.width
            }
            else {
                 fromViewEndFrame.origin.x -= containerView.frame.width
            }
            
            
            print("FromViewEnd: \(fromViewEndFrame.origin.x)")
            print("ToView: \(toView.frame.origin.x)")
            
            let toViewEndFrame = transitionContext.finalFrame(for: toVC)
            print("TOVIEWENDFRAM \(toViewEndFrame)")
            var toViewStartFrame = toViewEndFrame
            
            if decideWhereToGO > 0 {
                toViewStartFrame.origin.x -= containerView.frame.width
            } else{
                toViewStartFrame.origin.x += containerView.frame.width
            }
            print("TOVIEWENDFRAM \(toViewEndFrame)")
            toView.frame = toViewStartFrame
            
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: {
                toView.frame = toViewEndFrame
                fromView.frame = fromViewEndFrame
            }, completion: {
                (completed) -> Void in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(completed)
                containerView.clipsToBounds = true
                
            })
            
            
            
        
        }
    }

}
