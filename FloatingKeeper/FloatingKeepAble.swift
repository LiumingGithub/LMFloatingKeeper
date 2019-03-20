//
//  FloatingKeepAble.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

extension Notification.Name {
    public static let lm_didKeptByFloatingBar = Notification.Name(rawValue:"notifer.didKeepByFloatingBar")
}

// a viewcontroller Confirmed this protocol
// can be append to keeper
public typealias AnyFloatingKeepAble = FloatingKeepAble & UIViewController

public protocol FloatingKeepAble {

}

// 实现次协议并, 传给FloatingKeeperManager, 即可接入自定义的Floating bar 效果
public protocol FloatingBarManagerType {
    
    var currentFloatingBarFrameInWindow: CGRect { get }
    
    func didReceiveKeepAble(_ keepable: AnyFloatingKeepAble) -> Void
}

// MARK: -
// 管理添加到浮窗的控制器，未完成待补全
public class FloatingKeeperManager {
    
    struct Constant {
        static let floatingBarLength: CGFloat = 80
    }
    
    // singleton
    public static let shared = FloatingKeeperManager()
    private init() { }
    
    open var floatingBarManager: FloatingBarManagerType?
    
    //当前添加的ViewController
    public internal(set) var current: AnyFloatingKeepAble?
    
    // 当前FloatingBar位置
    // 这里只返回了一个随机的位置作为测试
    private let range = Range(uncheckedBounds: (lower: 1000, upper: 5000))
    open var currentFloatingBarFrame: CGRect {
        
        if let manager = floatingBarManager {
            return manager.currentFloatingBarFrameInWindow
        }
        
        if let randomY = range.randomElement() {
            return CGRect.init(x: 30, y: CGFloat(randomY) / 10.0 , width: Constant.floatingBarLength, height: Constant.floatingBarLength)
        }
        return CGRect.init(x: 30, y: 150, width: Constant.floatingBarLength, height: Constant.floatingBarLength)
    }
    
    open func received(_ element: AnyFloatingKeepAble) -> Void {
        
        if let old = current {
            print("old:\(old.classForCoder) will be override")
        }
        current = element
        print("new:\(element.classForCoder) is append to keeper")
        if let manager = floatingBarManager {
            manager.didReceiveKeepAble(element)
        }
    }
}
