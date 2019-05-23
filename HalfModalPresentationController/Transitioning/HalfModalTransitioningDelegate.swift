//
//  HalfModalTransitioningDelegate.swift
//  HalfModalPresentationController
//
//  Created by Martin Normark on 17/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class HalfModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var interactionController: HalfModalInteractiveTransition?
    
    var interactiveDismiss = true
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfModalTransitionAnimator(type: .Dismiss)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        interactionController = HalfModalInteractiveTransition(presented: presented)
        return HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactiveDismiss, let interactionController = interactionController, interactionController.isInteractive {
            return interactionController
        }
        
        return nil
    }
    
}

extension UIViewController { }
