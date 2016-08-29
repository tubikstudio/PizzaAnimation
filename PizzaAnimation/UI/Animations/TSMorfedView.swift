//
//  CheeseAnimation.swift
//  PizzaAnimation
//
//  Created by Tubik Studio on 8/4/16.
//  Copyright © 2016 Tubik Studio. All rights reserved.
//

import Foundation

import UIKit

extension CGPoint {
    
    init(withDistance distance: CGFloat, fromPoint startPoint: CGPoint, toPoint endPoint: CGPoint) {
        let angleAB = atan((endPoint.y - startPoint.y) - (endPoint.x - startPoint.x))
        let deltaXAC = distance * sin(angleAB)
        let resultX = startPoint.x + deltaXAC
        let deltaYAC = distance * cos(angleAB)
        let resultY = startPoint.y + deltaYAC
        self.init(x: resultX, y: resultY)
    }
    
}

struct RectPoints {
    
    var p1: CGPoint
    var p2: CGPoint
    var p3: CGPoint
    var p4: CGPoint
    
    static let zero = RectPoints(p1: CGPoint.zero, p2: CGPoint.zero, p3: CGPoint.zero, p4: CGPoint.zero)

}

@IBDesignable
final class TSMorfedView: UIView {
    
    //MARK: vars
    
    @IBInspectable
    var startLength: CGFloat = 0 {
        didSet {
            morf()
        }
    }
    
    @IBInspectable
    var midHeight: CGFloat = 0 {
        didSet {
            morf()
        }
    }
    
    @IBInspectable
    var startHeight: CGFloat = 0 {
        didSet {
            morf()
        }
    }
    @IBInspectable
    var startCenterY: CGFloat = 0 {
        didSet {
            morf()
        }
    }
    
    @IBInspectable
    var startOffset: CGFloat = 0 {
        didSet {
            morf()
        }
    }

    @IBInspectable
    var endHeight: CGFloat = 0 {
        didSet {
            morf()
        }
    }
    
    @IBInspectable
    var endCenterY: CGFloat = 0 {
        didSet {
            morf()
        }
    }
    
    @IBInspectable
    var endOffset: CGFloat = 0 {
        didSet {
            morf()
        }
    }
    
    @IBInspectable
    var gravityValue: CGFloat = 0 {
        didSet {
            morf()
        }
    }
    
    @IBInspectable
    var gravityPart: CGFloat = 0 { // 0-1
        didSet {
            morf()
        }
    }

    private var startBounds = CGRect.zero
    
    override var frame: CGRect {
        didSet {
            commonInit()
        }
    }
    
    //MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        startBounds = bounds
        morf()
    }
    
    //offset beatween 0 and 1
    func morf(offset: CGFloat = 0) {
        guard offset >= 0 && offset <= 1 else { return }
        
        let morfedPoints = framePoints(withOffset: offset)
        let path = morfedPath(fromRect: morfedPoints, percent: offset)
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }
    
    private func framePoints(withOffset offset: CGFloat) -> RectPoints {
        
        //point 1
        let point1 = CGPoint(x: startBounds.minX, y: startCenterY - startHeight/2.0 - offset * startOffset)
        
        let leftLength = (bounds.width - startLength)
        let lengthOffset = startLength + offset * leftLength
        
        
        //point 2
        let minY = ((endCenterY - endHeight/2.0) - endOffset)
        let maxY = CGPoint(withDistance: startLength, fromPoint: point1, toPoint: CGPoint(x: bounds.width, y: minY)).y - endOffset
        let point2 = CGPoint(x: lengthOffset, y: maxY - (maxY - minY) * offset)
        
        //point 4
        let point4 = CGPoint(x: startBounds.minX, y: point1.y + startHeight/2.0 - offset * startOffset)
        
        //point 3
        let point3 = CGPoint(x: point2.x, y: point2.y + endHeight/2.0 - offset * endOffset)
        
        return RectPoints(p1: point1, p2: point2, p3: point3, p4: point4)
    }
    
    private func morfedPath(fromRect rect: RectPoints, percent: CGFloat) -> UIBezierPath {
        let customPath = UIBezierPath()
        customPath.moveToPoint(rect.p1)
        let currentLength = rect.p2.x - rect.p1.x
        let controlPointY = rect.p1.y + percent * gravityValue
        var controlPoint = CGPoint(x: gravityPart * currentLength, y: controlPointY)
        customPath.addCurveToPoint(rect.p2, controlPoint1: controlPoint, controlPoint2: controlPoint)
        customPath.addLineToPoint(rect.p3)
        controlPoint = CGPoint(x: controlPoint.x, y: controlPointY + (1 - percent) * midHeight)
        customPath.addCurveToPoint(rect.p4, controlPoint1: controlPoint, controlPoint2: controlPoint)
        customPath.closePath()
        
        return customPath
    }
    
    override func prepareForInterfaceBuilder() {
        morf()
    }
    
}
