//
//  HalfModalInteractiveTransition.swift
//  HalfModalPresentationController
//
//  Created by Martin Normark on 28/01/16.
//  Copyright © 2016 martinnormark. All rights reserved.
//

import UIKit

class HalfModalInteractiveTransition: UIPercentDrivenInteractiveTransition {
    weak var presentedViewController: UIViewController?
    var panGestureRecognizer: UIPanGestureRecognizer
    
    private(set) var isInteractive = false
    private var hasStarted = false
    
    var shouldComplete: Bool = false
    
    init(presented: UIViewController?) {
        self.presentedViewController = presented
        self.panGestureRecognizer = UIPanGestureRecognizer()
        
        super.init()
        
        self.panGestureRecognizer.addTarget(self, action: #selector(onPan))
        presented?.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        
        print("start interactive")
    }
    
    override var completionSpeed: CGFloat {
        get {
            return 1.0 - self.percentComplete
        }
        set {}
    }
    
    @objc func onPan(pan: UIPanGestureRecognizer) -> Void {
        let translation = pan.translation(in: pan.view?.superview)
        
        switch pan.state {
        case .began:
            if !hasStarted {
                hasStarted = true
                isInteractive = true
                self.presentedViewController?.dismiss(animated: true, completion: nil)
            } else {
                pause()
            }
        case .changed:
            let screenHeight = UIScreen.main.bounds.size.height - 50
            let dragAmount = screenHeight
            let threshold: Float = 0.2
            var percent: Float = Float(translation.y) / Float(dragAmount)

            percent = fmaxf(percent, 0.0)
            percent = fminf(percent, 1.0)
            
            update(CGFloat(percent))
            
            shouldComplete = percent > threshold
        case .ended, .cancelled:
            if pan.state == .cancelled || !shouldComplete {
                cancel()
                
                print("cancel transition")
            }
            else {
                finish()
                
                print("finished transition")
            }
            isInteractive = false
            hasStarted = false
        default:
            cancel()
            isInteractive = false
            hasStarted = false
        }
    }
}
