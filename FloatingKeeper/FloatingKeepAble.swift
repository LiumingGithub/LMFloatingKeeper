//
//  FloatingKeepAble.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

extension Notification.Name {
    public static let lm_didTempSubcript = Notification.Name(rawValue:"notifer.lm_didTempSubcript")
}

// a viewcontroller Confirmed this protocol
// can be append to keeper
public typealias AnyFloatingKeepAble = FloatingKeepAble & UIViewController

public protocol FloatingKeepAble {
    
}

// MARK: -
// 管理添加到浮窗的控制器，未完成待补全
public class FloatingKeeperManager {
    
    struct Constant {
        static let floatingBarLength: CGFloat = 80
    }
    
    public static let shared = FloatingKeeperManager()
    
    //添加的ViewController
//    var controllers: [AnyFloatingKeepAble] = []
    public internal(set) var current: AnyFloatingKeepAble?
    
    // 当前FloatingBar位置
    // 这里只返回了一个随机的位置作为测试
    private let range = Range(uncheckedBounds: (lower: 1000, upper: 5000))
    open var currentFloatingBarFrame: CGRect {
        if let randomY = range.randomElement() {
            return CGRect.init(x: 30, y: CGFloat(randomY) / 10.0 , width: Constant.floatingBarLength, height: Constant.floatingBarLength)
        }
        return CGRect.init(x: 30, y: 150, width: Constant.floatingBarLength, height: Constant.floatingBarLength)
    }
    
    // sington
    private init() { }
    
    open func append(_ element: AnyFloatingKeepAble) -> Void {
        
//        controllers.append(element)
        if let old = current {
            print("old:\(old.classForCoder) will be override")
        }
        current = element
        print("new:\(element.classForCoder) is append to keeper")
    }
}
