//
//  AppleAnimatedTransitioning.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/16.
//  Copyright © 2019 com.ming. All rights reserved.
//

import UIKit

public enum AniTransitionTimeFuncion: Int {
    
    case easeInOut = 0, easeIn, easeOut, linear
    
    public var asAnimationOptions: UIView.AnimationOptions {
        switch self {
        case .easeIn:     return [.curveEaseIn]
        case .easeOut:    return [.curveEaseOut]
        case .linear:     return [.curveEaseOut]
        default:          return [.curveEaseInOut]
        }
    }
}

// 生成系统自带Transition动画的工厂类
public final class AppleAniTransitionProducer: AniTransitionProducerType {
    
    public enum AnimationType: Int {
        case curl = 0, flipVertical, flipHorizontal,crossDissolve
    }
    
    public var animationType: AnimationType = .flipVertical
    public var timeFunction: AniTransitionTimeFuncion = .easeInOut
    
    public func animation(from fromVC: UIViewController, to toVC: UIViewController, For operation: AniTransitionOperation) -> UIViewControllerAnimatedTransitioning? {
        
        if case .unknown = operation {
            return nil
        }
        
        let appearingView: UIView = toVC.view
        
        //  animation options from configuration
        var options = animationType.appleAnimation(for: operation)
        options.formUnion(timeFunction.asAnimationOptions)
        
        let animation = BlockAnimatedTransitioning(animate: {
            (during, context) in
            UIView.transition(with: context.containerView, duration: during, options: options, animations: {
                context.containerView.addSubview(appearingView)
            }) { (_) in
                let wasCancelled = context.transitionWasCancelled
                context.completeTransition(!wasCancelled)
            }
        })
        
        return animation
    }
}

extension AppleAniTransitionProducer.AnimationType {
    
    fileprivate func appleAnimation(for operation: AniTransitionOperation) -> UIView.AnimationOptions {
        switch (operation, self) {
        case (.forward, .curl):                 return [.transitionCurlUp]
        case (.forward, .flipVertical):         return [.transitionFlipFromTop]
        case (.forward, .flipHorizontal):       return [.transitionFlipFromLeft]
        case (.forward, .crossDissolve):        return [.transitionCrossDissolve]
        case (.backward, .curl):                return [.transitionCurlDown]
        case (.backward, .flipVertical):        return [.transitionFlipFromBottom]
        case (.backward, .flipHorizontal):      return [.transitionFlipFromRight]
        case (.backward, .crossDissolve):       return [.transitionCrossDissolve]
        default:
            return []
        }
    }
}
