//
//  NavigationTransitionAnimationMaker.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/16.
//  Copyright © 2019 com.ming. All rights reserved.
//
//  定义Transition动画的工厂类 的协议,
//  通过工厂类生成动画，更加灵活
//

import UIKit

public enum AniTransitionOperation: Int {
    
    case unknown
    
    //push & presente
    case forward
    
    //pop & dismiss
    case backward
    
    // init wiith UINavigationController Operation
    public init(_ operation: UINavigationController.Operation) {
        switch operation {
        case .push:    self = .forward;   break
        case .pop:     self = .backward;  break
        default:       self = .unknown;   break
        }
    }
}

public protocol AniTransitionProducerType {
    
    func animation(from fromVC: UIViewController, to toVC: UIViewController, For operation: AniTransitionOperation) -> UIViewControllerAnimatedTransitioning?
    
}


