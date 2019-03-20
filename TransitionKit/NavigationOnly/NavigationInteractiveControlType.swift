//
//  NavigationInteractiveTransitionControl.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

// MARK: Interactive Transitioning
public protocol NavigationInteractiveControlType: NavigationTransitionControlType {
    
    var interactiveProducer: InteractiveProducerType { get }
    
    var interactiveEnabled: Bool { get }
    
    var draggingGesture: UIPanGestureRecognizer? { get set}
    
    var draggingEdge: InteractiveDraggingEdge? { get set}
}

extension NavigationInteractiveControlType where Self: UINavigationController {
    
    public mutating func interactivePush(
        _ viewController: UIViewController,
        using draggingGesture: UIPanGestureRecognizer,
        draggingEdge: InteractiveDraggingEdge) -> Void {
        
        self.draggingGesture = draggingGesture
        self.draggingEdge = draggingEdge
        
        pushViewController(viewController, animated: true)
    }
    
    public mutating func interactivePop(
        using draggingGesture: UIPanGestureRecognizer,
        draggingEdge: InteractiveDraggingEdge) -> Void {
        
        self.draggingGesture = draggingGesture
        self.draggingEdge = draggingEdge
        
        popViewController(animated: true)
    }
}
