//
//  NavigationAnimating.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/16.
//  Copyright © 2019 com.ming. All rights reserved.
//

import UIKit

// MARK: Transitioning Animation Only
public protocol NavigationTransitionControlType {
    
    var aniTransitionProducer: AniTransitionProducerType { get}
}

extension NavigationTransitionControlType where Self: UINavigationControllerDelegate {
    
    public func noobj_navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return aniTransitionProducer.animation(from: fromVC, to: toVC, For: AniTransitionOperation(operation))
    }
}
