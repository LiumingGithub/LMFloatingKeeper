//
//  File.swift
//  LMAnimatedTransition
//
//  Created by 刘明 on 2019/3/17.
//  Copyright © 2019 com.ming. All rights reserved.
//
//
//  生成使用frame变化效果的Transition动画的工厂类
//  该类动画只需要在计算出动画前后的frame, 然后调用 UIView.animate 即可

import UIKit

open class FrameAniTransitionProducer: AniTransitionProducerType {
    
    struct Constant {
        static let crowd: CGFloat       = 0.3
        static let squeezed: CGFloat    = 15
    }
    
    /// 上层的viewcontroller 动画效果
    /// pop时为fromVC，push 时为toVC
    /// 这里定义了从屏幕四个方向进入
    public enum UponAnimationType: Int {
        case fromLeft = 0, fromRight, fromTop, fromBottom
    }
    
    /// 下的viewcontroller 动画效果
    /// pop时为toVC，push 时为fromVC
    ///
    /// none: 不移动
    /// pushed: 被推出屏幕外
    /// crowd: 部分被推出屏幕外，Constant定义默认被推出的比例
    /// squeezed: 四边缩进效果，Constant定义默认的缩进距离
    public enum UnderAnimationType: Int {
        case none = 0, pushed, crowd, squeezed
    }
    
    open var uponAnimationType: UponAnimationType = .fromRight
    open var underAnimationType: UnderAnimationType = .crowd
    open var timeFunction: AniTransitionTimeFuncion = .easeInOut
    
    // 如果将手势添加在UIViewcontroller.view 上，
    // 测试只有左右方向的动画可以 Interactive
    fileprivate var isInteractiveTransition: Bool {
        switch (underAnimationType, uponAnimationType) {
        case (_, .fromLeft), (_, .fromRight):
            return true
        default:
            return false
        }
    }
    
    public func animation(from fromVC: UIViewController, to toVC: UIViewController, For operation: AniTransitionOperation) -> UIViewControllerAnimatedTransitioning? {
        
        let animationOptions = timeFunction.asAnimationOptions
        let interruptible = self.isInteractiveTransition
        
        let uponAnimation = self.uponAnimationType
        let underAimation = self.underAnimationType
        
        switch operation {
        case .forward:
            let uponVC = toVC
            let uponView: UIView = uponVC.view
            let underVC = fromVC
            let underView: UIView = underVC.view
            return BlockAnimatedTransitioning(0.3, interruptible: interruptible, animate: { (during, context) in
                let uponFinalFrame = context.finalFrame(for: uponVC)
                let underInitialFrame = context.initialFrame(for: underVC)
                
                let underFinalFrame = underAimation.animatedFrame(from: underInitialFrame, uponAnimation)
                uponView.frame = uponAnimation.animatedFrame(from: underInitialFrame)
                
                UIView.animate(withDuration: during, delay: 0, options: animationOptions, animations: {
                    context.containerView.addSubview(uponView)
                    uponView.frame = uponFinalFrame
                    underView.frame = underFinalFrame
                }, completion: { (_) in
                    let wasCancelled = context.transitionWasCancelled
                    context.completeTransition(!wasCancelled)
                    underVC.view.frame = underInitialFrame
                })
            })
            
        case .backward:
            let uponVC = fromVC
            let uponView: UIView = uponVC.view
            let underVC = toVC
            let underView: UIView = underVC.view
            return BlockAnimatedTransitioning(0.3, interruptible: interruptible, animate: { (during, context) in
                
                let uponInitialFrame = context.initialFrame(for: uponVC)
                let underFinalFrame = context.finalFrame(for: underVC)
                
                underView.frame = underAimation.animatedFrame(from: underFinalFrame, uponAnimation)
                let uponFinalFrame = uponAnimation.animatedFrame(from: uponInitialFrame)
                
                UIView.animate(withDuration: during, delay: 0, options: animationOptions, animations: {
                    context.containerView.insertSubview(underView, at: 0)
                    uponView.frame = uponFinalFrame
                    underView.frame = underFinalFrame
                }, completion: { (_) in
                    let wasCancelled = context.transitionWasCancelled
                    context.completeTransition(!wasCancelled)
                })
            })
            
        default:
            return nil
        }
    }
}

extension FrameAniTransitionProducer.UponAnimationType {
    
    func animatedFrame(from frame: CGRect) -> CGRect {
        switch self {
        case .fromBottom:
            return frame.offsetBy(dx: 0, dy: frame.maxY)
        case .fromTop:
            return frame.offsetBy(dx: 0, dy: -frame.maxY)
        case .fromLeft:
            return frame.offsetBy(dx: -frame.maxX, dy: 0)
        case .fromRight:
            return frame.offsetBy(dx: frame.maxX, dy: 0)
        }
    }
}

extension FrameAniTransitionProducer.UnderAnimationType {
    
    public func animatedFrame(from frame: CGRect, _ uponAnimation: FrameAniTransitionProducer.UponAnimationType) -> CGRect {
        switch self {
        case .pushed:
            let arg: CGFloat = -1
            return uponAnimation.animatedFrame(from: frame) * (arg, arg)
        case .crowd:
            let arg = -FrameAniTransitionProducer.Constant.crowd
            return uponAnimation.animatedFrame(from: frame) * (arg, arg)
        case .squeezed:
            let arg = FrameAniTransitionProducer.Constant.squeezed
            return frame.insetBy(dx: arg, dy: arg)
        default:
            return frame
        }
    }
}

// MARK: -
extension CGRect {
    
    fileprivate static func * (lhs: CGRect, rhs: (CGFloat, CGFloat)) -> CGRect {
        return CGRect.init(x: lhs.origin.x * rhs.0, y: lhs.origin.y * rhs.1, width: lhs.width, height: lhs.height)
    }
}

