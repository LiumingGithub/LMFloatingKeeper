//
//  NavigationController.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    open var isInteractivePopEnabled = false
    
    /*
    //普通转场动画控制器初始化方法
    let generateControl: GeneralTransitionControl = {
        //transaction动画
        let transactionProducer = FrameAniTransitionProducer()
        //设置动画效果
        transactionProducer.underAnimationType = .pushed
        transactionProducer.uponAnimationType = .fromLeft
        
        //interactive动画
        let interactiveProducer = GeneralInteractiveProducer()
        
        return GeneralTransitionControl(aniTransitionProducer: transactionProducer, interactiveProducer: interactiveProducer)
    }()
    */
    
    // 微信悬浮窗效果的转场动画控制器
    let floatingControl: FloatingKeeperControl = {
        let control = FloatingKeeperControl()
        // 设定需要动画效果
        control.floatingTransitionProducer.underAnimationType = .squeezed
        control.floatingTransitionProducer.uponAnimationType = .fromLeft
        
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设定好转场动画控制器之后，设置为UINavigationController 的delegate
        // 若已设置, 则需要实现NavigationInteractiveControlType，并
        // 重写 navigationController(_:animationControllerFor:from:to:) 和 navigationController(_:interactionControllerFor:)方法，
        // 可参照 GeneralTransitionControl
        delegate = floatingControl
        
        interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return isInteractivePopEnabled && viewControllers.count > 1
    }
}
