//
//  TFForwardAnimator.swift
//  TFTransparentNavigationBar
//
//  Created by Ales Kocur on 10/03/2015.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

import UIKit

class TFForwardAnimator: TFNavigationBarAnimator, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        
        let containerView = context.containerView
        let toView = context.view(forKey: UITransitionContextViewKey.to)!
        let fromView = context.view(forKey: UITransitionContextViewKey.from)!
        let options: UIViewAnimationOptions = isInteractive ? [.curveLinear] : [.curveEaseOut]
        let duration = self.transitionDuration(using: context)
        
        // Insert toView above from view
        containerView.insertSubview(toView, aboveSubview: fromView)
        
        switch navigationBarStyleTransition {
        case .toTransparent:
            animateToTransparent(containerView, fromView: fromView, toView: toView, duration: duration, options: options, context: context)
        case .toSolid:
            animateToSolid(containerView, fromView: fromView, toView: toView, duration: duration, options: options, context: context)
        case .toSame: 
            animateToSame(containerView, fromView: fromView, toView: toView, duration: duration, options: options, context: context)
        }
    }
    
    
    func animateToSolid(_ containerView: UIView, fromView: UIView, toView: UIView, duration: TimeInterval, options: UIViewAnimationOptions, context: UIViewControllerContextTransitioning) {
        
        let fromViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        // Create snapshot from navigation controller content
        let fromViewSnapshot = fromViewController.navigationController!.view.snapshotView(afterScreenUpdates: false)!
        
        // Create snapshot of navigation bar
        navigationController.createNavigationBarSnapshot(fromViewController)
        
        // Insert fromView snapshot above fromView
        containerView.insertSubview(fromViewSnapshot, belowSubview: toView)
        
        // hide fromView and use snapshot instead
        fromView.isHidden = true
        
        self.navigationController.setupNavigationBarByStyle(self.navigationBarStyleTransition)
        
        let navigationControllerFrame = navigationController.view.frame
        
        var toViewFinalFrame = context.finalFrame(for: toViewController)
        toViewFinalFrame = toViewFinalFrame.additiveRect(-64, direction: .top)
        
        // Move toView to the right
        toView.frame = toViewFinalFrame.offsetBy(dx: toViewFinalFrame.width, dy: 0)
        
        // Calculate final frame for fromView and fromViewSnapshot
        let fromViewFinalFrame = navigationControllerFrame.offsetBy(dx: -(navigationControllerFrame.width * 0.3), dy: 0)
        
        // Save origin navigation bar frame
        let navigationBarFinalFrame = self.navigationController.navigationBar.frame
        
        // Shift bar
        self.navigationController.navigationBar.frame = navigationBarFinalFrame.offsetBy(dx: navigationBarFinalFrame.width, dy: 0)
        
        addShadows([toView])
        
        
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: { () -> Void in
            
            toView.frame = toViewFinalFrame
            fromViewSnapshot.frame = fromViewFinalFrame
            
            // Shift navigation bar
            self.navigationController.navigationBar.frame = navigationBarFinalFrame
            
            }, completion: { (completed) -> Void in
                // Show fromView
                fromView.frame = fromViewFinalFrame
                fromView.isHidden = false
                // Remove snapshot
                fromViewSnapshot.removeFromSuperview()
                // Inform about transaction completion state
                context.completeTransition(!context.transitionWasCancelled)
        })
        
    }
    
    
    func animateToTransparent(_ containerView: UIView, fromView: UIView, toView: UIView, duration: TimeInterval, options: UIViewAnimationOptions, context: UIViewControllerContextTransitioning) {
        
        let fromViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        // Create snapshot from navigation controller content
        let fromViewSnapshot = fromViewController.navigationController!.view.snapshotView(afterScreenUpdates: false)!
        
        // Create snapshot of navigation bar
        navigationController.createNavigationBarSnapshot(fromViewController)
        
        // Insert fromView snapshot above fromView
        containerView.insertSubview(fromViewSnapshot, belowSubview: toView)
        
        // hide fromView and use snapshot instead
        fromView.isHidden = true
        
        self.navigationController.setupNavigationBarByStyle(self.navigationBarStyleTransition)
        
        let navigationControllerFrame = navigationController.view.frame
        
        let toViewFinalFrame: CGRect = context.finalFrame(for: toViewController)
        
        // Move toView to the right
        toView.frame = toViewFinalFrame.offsetBy(dx: toViewFinalFrame.width, dy: 0)
        
        // Calculate final frame for fromView and fromViewSnapshot
        let fromViewFinalFrame = navigationControllerFrame.offsetBy(dx: -(navigationControllerFrame.width * 0.3), dy: 0)
        
        // Save origin navigation bar frame
        let navigationBarFrame = self.navigationController.navigationBar.frame
        
        // Shift bar
        self.navigationController.navigationBar.frame = navigationBarFrame.offsetBy(dx: navigationBarFrame.width, dy: 0)
        
        addShadows([toView])
        
        
        
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: { () -> Void in
            
            toView.frame = toViewFinalFrame
            fromViewSnapshot.frame = fromViewFinalFrame
            
            // Shift navigation bar
            self.navigationController.navigationBar.frame = navigationBarFrame
            
            }, completion: { (completed) -> Void in
                // Show fromView
                fromView.frame = fromViewFinalFrame
                fromView.isHidden = false
                // Remove snapshot
                fromViewSnapshot.removeFromSuperview()
                // Inform about transaction completion state
                context.completeTransition(!context.transitionWasCancelled)
        })
    }
    
    func animateToSame(_ containerView: UIView, fromView: UIView, toView: UIView, duration: TimeInterval, options: UIViewAnimationOptions, context: UIViewControllerContextTransitioning) {
        
        let fromViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let toViewFinalFrame = context.finalFrame(for: toViewController)
        
        // Shift to the right
        toView.frame = toViewFinalFrame.offsetBy(dx: toViewFinalFrame.width, dy: 0)
        
        let fromViewFinalFrame: CGRect = {
            let initialFrame = context.initialFrame(for: fromViewController)
            return initialFrame.offsetBy(dx: -(initialFrame.width * 0.3), dy: 0)
        }()
        
        addShadows([toView])
        
        
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: { () -> Void in
            
            toView.frame = toViewFinalFrame
            fromView.frame = fromViewFinalFrame
            
            }, completion: { (completed) -> Void in

                // Inform about transaction completion state
                context.completeTransition(!context.transitionWasCancelled)
        })
    }
}
