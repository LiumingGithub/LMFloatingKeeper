//
//  FloatingKeeperInr.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

open class FloatingKeeperPopTransation: BaseAnimatedTransitioning {
    struct Constant {
        static let defaultTransationDuring  = 0.3
        static let defaultInteractiveDuring = 0.3
    }
    
    public enum UponAnimationType: Int{
        case fromLeft = 0, fromRight
    }
    
    open override var isInterruptible: Bool {
        get { return true }
        set { }
    }
    
    open var uponAnimationType: UponAnimationType  = .fromRight
    open var underAnimationType: FrameAniTransitionProducer.UnderAnimationType = .crowd

    open override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let uponVC = transitionContext.viewController(forKey: .from),
            let underVC = transitionContext.viewController(forKey: .to) else {
                return
        }
        
        let uponView: UIView = uponVC.view
        let underView: UIView = underVC.view
        
        let uponInitialFrame = transitionContext.initialFrame(for: uponVC)
        let underFinalFrame = transitionContext.finalFrame(for: underVC)
        
        underView.frame = underAnimationType.animatedFrame(from: underFinalFrame, uponAnimationType.asFrameAnimationType)
        
        let uponFinalFrame = uponAnimationType.animatedFrame(from: uponInitialFrame)
        
        let during = transitionDuration(using: transitionContext)
        
        // 是否被加入到浮窗的标识
        var wasKeeped = false
        
        UIView.animate(withDuration: during, delay: 0, options: [.curveEaseInOut], animations: {
            transitionContext.containerView.insertSubview(underView, at: 0)
            uponView.frame = uponFinalFrame
            underView.frame = underFinalFrame
        }, completion: { (_) in
            // 如果被添加到浮窗，这就不能再调用 transitionContext.completeTransition(_)
            if wasKeeped { return }
            
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        })
        
        //获取当前浮窗的frame, 即为动画最终的frame
        let endFrame = FloatingKeeperManager.shared.currentFloatingBarFrame
        let raduis = endFrame.width * 0.5
       
        guard let coordinator = uponVC.transitionCoordinator else { return }
        coordinator.notifyWhenInteractionEnds({ (context) in
            if !context.isInteractive && !context.isCancelled {
               
                // 检查是否被加入到了浮窗
                guard case let .some(vc) = FloatingKeeperManager.shared.current,
                    vc == uponVC else {
                        return
                }
                
                //如果加入到浮窗，修改wasKeeped， 并执行新的动画
                wasKeeped = true
                
                let interactiveDuring: TimeInterval = Constant.defaultInteractiveDuring
                let currentframe = uponView.frame
                uponView.frame = currentframe
                
                // 在view移动回uponInitialFrame 的过程中，使用mask动画，
                // 形成移动和frame渐变的效果
                UIView.animate(withDuration: interactiveDuring, animations: {
                    uponView.frame = uponInitialFrame
                    UIView.performWithoutAnimation {
                        let mask = AnimatableBlockMaskView.init(animationDuring: interactiveDuring, animate: { (percent, rect) -> ShapeConvertable in
                            let maskdrawRect = rect.lm.transform(to: endFrame, percent: percent)
                            return CGPath.init(roundedRect: maskdrawRect, cornerWidth: raduis, cornerHeight: raduis, transform: nil)
                        })
                        mask.frame = uponView.bounds
                        uponView.mask = mask
                    }
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
                    uponView.mask = nil
                })
            }
        })
    }
}


extension FloatingKeeperPopTransation.UponAnimationType {
    
    public func animatedFrame(from frame: CGRect) -> CGRect {
        switch self {
        case .fromLeft:
            return frame.offsetBy(dx: -frame.maxX, dy: 0)
        case .fromRight:
            return frame.offsetBy(dx: frame.maxX, dy: 0)
        }
    }
    
    public var asFrameAnimationType: FrameAniTransitionProducer.UponAnimationType {
        return FrameAniTransitionProducer.UponAnimationType(rawValue: rawValue)!
    }
}
