//
//  BlockShapeMakerMaskView.swift
//  LMFloatingKeeper
//
//  Created by 刘明 on 2019/3/19.
//  Copyright © 2019 ming.liu. All rights reserved.
//

import UIKit

public final class BlockShapeMaskView: BaseShapeMaskView {
    
    public typealias ShapeMakingExecution = (CGRect) -> ShapeConvertable
    public var shapemaker: ShapeMakingExecution? = nil
    
    public convenience init(execute: @escaping ShapeMakingExecution) {
        self.init(frame: CGRect.zero)
        self.shapemaker = execute
    }
    
    public override func makeShape(inRect rect: CGRect) -> ShapeConvertable {
        if let closure = shapemaker {
            return closure(rect)
        }
        return super.makeShape(inRect: rect)
    }
}
