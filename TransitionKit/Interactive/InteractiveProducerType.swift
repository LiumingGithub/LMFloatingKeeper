//
//  int.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/17.
//  Copyright © 2019 com.ming. All rights reserved.
//
//  与Transition动画类似, InteractiveTransition 也使用工厂类生产
//  便于扩展

import UIKit

/// Interactive 手势添加的方位，
/// 对应 UIScreenEdgePanGestureRecognizer的 UIRectEdge
public enum InteractiveDraggingEdge: Int {
    case top = 0, bottom, left, right
    public var asRectEdge: UIRectEdge {
        switch self {
        case .top:      return .top
        case .bottom:   return .bottom
        case .left:     return .left
        case .right:    return .right
        }
    }
}

extension FrameAniTransitionProducer.UponAnimationType {
    public func recommendInteractiveEdge(for operation: AniTransitionOperation) -> InteractiveDraggingEdge? {
        switch (self, operation) {
        case (.fromRight, .backward), (.fromLeft, .forward):  return .left
        case (.fromLeft, .backward), (.fromRight, .forward):  return .right
        default: return nil
        }
    }
}

public protocol InteractiveProducerType {
    
    func interactionControllerFor(
        _ animationController: UIViewControllerAnimatedTransitioning,
        draggingGesture: UIPanGestureRecognizer,
        draggingEdg: InteractiveDraggingEdge) -> UIViewControllerInteractiveTransitioning?
}




