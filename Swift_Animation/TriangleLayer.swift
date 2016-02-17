//
//  TriangleLayer.swift
//  Swift_Animation
//
//  Created by coder on 16/2/15.
//  Copyright © 2016年 coder. All rights reserved.
//

import UIKit

class TriangleLayer: CAShapeLayer {

    let innerPadding: CGFloat = 20;
    override init() {
        super.init()
        fillColor   = UIColor.redColor().CGColor
        strokeColor = UIColor.redColor().CGColor
        lineWidth   = 7
        lineCap     = kCALineCapRound
        lineJoin    = kCALineJoinRound
        path = trianglePathSmall.CGPath;
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var trianglePathSmall: UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.moveToPoint(CGPoint(x: 5.0 + innerPadding, y: 95.0))
        trianglePath.addLineToPoint(CGPoint(x: 50.0, y: 12.5 + innerPadding))
        trianglePath.addLineToPoint(CGPoint(x: 95.0 - innerPadding, y: 95.0))
        trianglePath.closePath()
        return trianglePath
    }
    
    var trianglePathLeftExtension: UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.moveToPoint(CGPoint(x: 5.0, y: 95.0))
        trianglePath.addLineToPoint(CGPoint(x: 50.0, y: 12.5 + innerPadding))
        trianglePath.addLineToPoint(CGPoint(x: 95.0 - innerPadding, y: 95.0))
        trianglePath.closePath()
        return trianglePath
    }
    
    var trianglePathRightExtension: UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.moveToPoint(CGPoint(x: 5.0, y: 95.0))
        trianglePath.addLineToPoint(CGPoint(x: 50.0, y: 12.5 + innerPadding))
        trianglePath.addLineToPoint(CGPoint(x: 95.0, y: 95.0))
        trianglePath.closePath()
        return trianglePath
    }
    
    var trianglePathTopExtension: UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.moveToPoint(CGPoint(x: 5.0, y: 95.0))
        trianglePath.addLineToPoint(CGPoint(x: 50.0, y: 12.5))
        trianglePath.addLineToPoint(CGPoint(x: 95.0, y: 95.0))
        trianglePath.closePath()
        return trianglePath
    }

    
    func animation() {
        let animation1:CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation1.fromValue = trianglePathSmall.CGPath
        animation1.toValue   = trianglePathLeftExtension.CGPath
        animation1.fillMode  = kCAFillModeBackwards
        animation1.removedOnCompletion = false
        animation1.duration  = 0.3
        
        let animation2:CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation2.fromValue = trianglePathLeftExtension.CGPath
        animation2.toValue   = trianglePathRightExtension.CGPath
        animation2.beginTime = animation1.beginTime + animation1.duration
        animation2.duration  = 0.25
        
        let animation3:CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation3.fromValue = trianglePathRightExtension.CGPath
        animation3.toValue   = trianglePathTopExtension.CGPath
        animation3.beginTime = animation2.beginTime + animation2.duration
        animation3.duration  = 0.2
        
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [animation1,animation2,animation3]
        animationGroup.beginTime  = CACurrentMediaTime()
        animationGroup.duration   = animation3.beginTime + animation3.duration
        animationGroup.fillMode   = kCAFillModeForwards
        animationGroup.removedOnCompletion = false
        addAnimation(animationGroup, forKey: nil)
    }
    
}
