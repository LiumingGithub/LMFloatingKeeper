//
//  GeneralNavigationTransitionControl.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

open class GeneralTransitionControl: NSObject, UINavigationControllerDelegate,
NavigationInteractiveControlType {
    
    /// NavigationInteractiveControl properties
    open var interactiveProducer: InteractiveProducerType = GeneralInteractiveProducer()
    open var aniTransitionProducer: AniTransitionProducerType = FrameAniTransitionProducer()
    open var interactiveEnabled: Bool = true
    open var draggingGesture: UIPanGestureRecognizer? = nil
    open var draggingEdge: InteractiveDraggingEdge? = nil
    
    // MARK: - UINavigationControllerDelegate
    open func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return aniTransitionProducer.animation(from: fromVC, to: toVC, For: AniTransitionOperation(operation))
    }
    
    open func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        ///该处一定要将draggingGesture在返回前设置为nil，否则会出现系统返回失效的bug
        defer {
            draggingGesture = nil
        }
        guard interactiveEnabled,
            let gesture = draggingGesture,
            let edge = draggingEdge else {
                return nil
        }
        return interactiveProducer.interactionControllerFor(animationController, draggingGesture: gesture, draggingEdg: edge)
    }
}
