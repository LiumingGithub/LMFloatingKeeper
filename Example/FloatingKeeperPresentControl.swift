//
//  PresentControl.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/20.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

extension NameSpaceWrapper where T: UIViewController {
    
    public func preset(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion:(() -> Void)?) -> Void
        {
        FloatingKeeperPresentControl.shared.presentAnimate(from: value, to: viewControllerToPresent, animated: flag, completion: completion)
    }
}

// 浮窗的present效果实现
public class FloatingKeeperPresentControl: NSObject, UIViewControllerTransitioningDelegate {
    
    // singleton
    public static let shared = FloatingKeeperPresentControl()
    private override init() {
        super.init()
    }
    
    public func presentAnimate(from fromVC: UIViewController, to toVC: UIViewController, animated flag: Bool, completion:(() -> Void)?) -> Void {
        toVC.transitioningDelegate = self
        toVC.modalPresentationStyle = .overFullScreen
        fromVC.present(toVC, animated: flag, completion: completion)
    }
    
    //MARK: - UIViewControllerTransitioningDelegate
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let floatingBarCurrentFrame = FloatingKeeperManager.shared.currentFloatingBarFrame
        return produceAnimation(dismissed, initialFrame: floatingBarCurrentFrame, isforPresented: false)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let floatingBarCurrentFrame = FloatingKeeperManager.shared.currentFloatingBarFrame
        return produceAnimation(presented, initialFrame: floatingBarCurrentFrame, isforPresented: true)
    }
    
    // MARK: -
    fileprivate func produceAnimation(
        _ uponViewController: UIViewController,
        initialFrame: CGRect,
        transitionDuring: TimeInterval = 0.5,
        isforPresented: Bool) -> UIViewControllerAnimatedTransitioning {
        return BlockAnimatedTransitioning(transitionDuring, interruptible: false, animate: { (during, context) in
            let uponView: UIView = uponViewController.view
            
            let uponViewFinalFrame = context.finalFrame(for: uponViewController)
            let radius = initialFrame.width * 0.5
            
            // 如果这里frame不做任何改变, animate直接就到completion
            uponView.frame = uponViewFinalFrame.insetBy(dx: 0.5, dy: 0.5)
            
            UIView.animate(withDuration: during, animations: {
                if isforPresented { context.containerView.addSubview(uponView) }
                uponView.frame = uponViewFinalFrame
                
                UIView.performWithoutAnimation {
                    let mask = AnimatableBlockMaskView(animationDuring: during, automaticallyFire: true, animate: { (percent, rect) -> ShapeConvertable in
                        let realPercent = isforPresented ? percent : (1 - percent)
                        // 这里对 percent 做幂次处理，形成加速效果
                        let newRect = initialFrame.lm.transform(to: rect, percent: realPercent * realPercent * realPercent)
                        
                        return CGPath(roundedRect: newRect, cornerWidth: radius, cornerHeight: radius, transform: nil)
                    })
                    uponView.mask = mask
                    mask.frame = uponView.bounds
                }
                
            }, completion: { (_) in
                uponView.mask = nil
                let wasCancelled = context.transitionWasCancelled
                context.completeTransition(!wasCancelled)
            })
            
        }, endedClosure: nil)
    }
    
}

