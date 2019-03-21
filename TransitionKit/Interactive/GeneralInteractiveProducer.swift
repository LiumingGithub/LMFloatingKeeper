//
//  GeneralInteractiveProducer.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

open class GeneralInteractiveProducer: InteractiveProducerType {
    
    open var supportEdges: [InteractiveDraggingEdge] = [.left, .right, .left, .right]
    
    open func interactionControllerFor(
        _ animationController: UIViewControllerAnimatedTransitioning,
        draggingGesture: UIPanGestureRecognizer,
        draggingEdg: InteractiveDraggingEdge) -> UIViewControllerInteractiveTransitioning? {
        
        if let interruptible = animationController as? AnimatedTransitioningInterruptible, interruptible.isInterruptible {
            return BaseGestureInteractive(draggingGesture, draggingEdge: draggingEdg)
        }
        return nil
    }
}
