//
//  FloatingKeeperControl.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

public class FloatingKeepInteractiveProducer: InteractiveProducerType {
    
    var producer = GeneralInteractiveProducer()
    
    public func interactionControllerFor(_ animationController: UIViewControllerAnimatedTransitioning, draggingGesture: UIPanGestureRecognizer, draggingEdg: InteractiveDraggingEdge) -> UIViewControllerInteractiveTransitioning? {
        
        if animationController is FloatingKeeperPopTransation {
            return FloatingKeeperInteractive(draggingGesture, draggingEdge: draggingEdg)
        }
        return producer.interactionControllerFor(animationController, draggingGesture:draggingGesture, draggingEdg: draggingEdg)
    }
    
}

public class FloatingKeepTransitionProducer: AniTransitionProducerType {
    
    open var uponAnimationType: FloatingKeeperPopTransation.UponAnimationType  = .fromRight {
        didSet {
            resetAnimation()
        }
    }
    
    open var underAnimationType: FrameAniTransitionProducer.UnderAnimationType = .squeezed {
        didSet {
            resetAnimation()
        }
    }
    
    var producer: FrameAniTransitionProducer = FrameAniTransitionProducer()
    
    public init() {
       resetAnimation()
    }
    
    fileprivate func resetAnimation() -> Void {
        producer.underAnimationType = underAnimationType
        producer.uponAnimationType = uponAnimationType.asFrameAnimationType
    }
    
    public func animation(from fromVC: UIViewController, to toVC: UIViewController, For operation: AniTransitionOperation) -> UIViewControllerAnimatedTransitioning? {
        if case .backward = operation, fromVC is FloatingKeepAble {
            let animation = FloatingKeeperPopTransation(0.3, interruptible: true)
            animation.uponAnimationType = uponAnimationType
            animation.underAnimationType = underAnimationType
            return animation
        }
        return producer.animation(from:fromVC, to:toVC, For: operation)
    }
}

open class FloatingKeeperControl: NSObject, UINavigationControllerDelegate, NavigationInteractiveControlType {
    
    public var aniTransitionProducer: AniTransitionProducerType = FloatingKeepTransitionProducer()
    public var interactiveProducer: InteractiveProducerType = FloatingKeepInteractiveProducer()
    public var interactiveEnabled: Bool = true
    public var draggingGesture: UIPanGestureRecognizer? = nil
    public var draggingEdge: InteractiveDraggingEdge? = nil
    
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
