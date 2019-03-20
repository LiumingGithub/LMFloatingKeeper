//
//  NavigationController.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    let control = FloatingKeeperControl()
    
    open var isInteractivePopEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = control
        interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return isInteractivePopEnabled && viewControllers.count > 1
    }
}
