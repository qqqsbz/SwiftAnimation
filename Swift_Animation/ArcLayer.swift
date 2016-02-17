//
//  ArcLayer.swift
//  Swift_Animation
//
//  Created by coder on 16/2/16.
//  Copyright © 2016年 coder. All rights reserved.
//

import UIKit

class ArcLayer: CAShapeLayer {

    let anFillColor:CGColorRef   = UIColor(red: 60.0/255.0, green: 115.0/255.0, blue: 146.0/255.0, alpha: 1.0).CGColor
    
    let animationDuration:NSTimeInterval = 0.17
    var completeHandler:((flag:Bool) -> Void)?
    
    var sWidth:CGFloat  = 0.0
    var sHeight:CGFloat = 0.0
    var sy:CGFloat      = 0.0
    var sLag:CGFloat    = 20.0
    let sRange:CGFloat  = 15.0
    init(bounds:CGRect) {
        super.init()
        self.sWidth  = bounds.width
        self.sHeight = bounds.height
        self.sLag    = self.sHeight / 5
        self.fillColor = anFillColor
        self.path = arcPathPre.CGPath
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var arcPathPre: UIBezierPath {
        let arcPath = UIBezierPath()
        arcPath.moveToPoint(CGPoint(x: 0, y: sHeight))
        arcPath.addLineToPoint(CGPoint(x: 0, y: sHeight))
        arcPath.addLineToPoint(CGPoint(x: sWidth, y: sHeight))
        arcPath.addLineToPoint(CGPoint(x: sWidth, y: sHeight))
        arcPath.addLineToPoint(CGPoint(x: 0, y: sHeight))
        arcPath.closePath()
        return arcPath

    }
    
    var arcPathStarting: UIBezierPath {
        sy = sHeight - sLag;
        let startPath = UIBezierPath()
        startPath.moveToPoint(CGPoint(x: 0, y: sHeight))
        startPath.addLineToPoint(CGPoint(x: 0, y: sy))
        startPath.addCurveToPoint(CGPoint(x: sWidth, y: sy), controlPoint1: CGPoint(x: 0.0, y: sy - sRange), controlPoint2: CGPoint(x: sWidth + sLag, y: sy + sRange))
        startPath.addLineToPoint(CGPoint(x: sWidth, y: sHeight))
        startPath.addLineToPoint(CGPoint(x: 0, y: sHeight))
        startPath.closePath()
        return startPath;
    }
    
    var arcPathLow: UIBezierPath {
        sy = sHeight - sLag * 2;
        let lowPath = UIBezierPath()
        lowPath.moveToPoint(CGPoint(x: 0, y: sHeight))
        lowPath.addLineToPoint(CGPoint(x: 0, y: sy))
        lowPath.addCurveToPoint(CGPoint(x: sWidth, y: sy), controlPoint1: CGPoint(x: sWidth - sLag, y: sy + sRange), controlPoint2: CGPoint(x: sWidth + sLag, y: sy - sRange))
        lowPath.addLineToPoint(CGPoint(x: sWidth, y: sHeight))
        lowPath.addLineToPoint(CGPoint(x: 0, y: sHeight))
        lowPath.closePath()
        return lowPath
    }
    
    var arcPathHigh: UIBezierPath {
        sy = sHeight - sLag * 3;
        let highPath = UIBezierPath()
        highPath.moveToPoint(CGPoint(x: 0, y: sHeight))
        highPath.addLineToPoint(CGPoint(x: 0, y: sy))
        highPath.addCurveToPoint(CGPoint(x: sWidth, y: sy), controlPoint1: CGPoint(x: sWidth, y: sy - sRange), controlPoint2: CGPoint(x: sWidth + sLag, y: sy + sRange))
        highPath.addLineToPoint(CGPoint(x: sWidth, y: sHeight))
        highPath.addLineToPoint(CGPoint(x: 0, y: sHeight))
        highPath.closePath()
        return highPath;
    }
    
    var arcPathMid: UIBezierPath {
        sy = sHeight - sLag * 4;
        let midPath = UIBezierPath()
        midPath.moveToPoint(CGPoint(x: 0.0, y: sHeight))
        midPath.addLineToPoint(CGPoint(x: 0.0, y: sy))
        midPath.addCurveToPoint(CGPoint(x: sWidth, y: sy), controlPoint1: CGPoint(x: sWidth, y: sy + sRange), controlPoint2: CGPoint(x: sWidth, y: sy - sRange))
        midPath.addLineToPoint(CGPoint(x: sWidth, y: sHeight))
        midPath.addLineToPoint(CGPoint(x: 0.0, y: sHeight))
        midPath.closePath()
        return midPath
    }
    
    var arcPathComplete: UIBezierPath {
        let completePath = UIBezierPath()
        completePath.moveToPoint(CGPoint(x: 0, y: sHeight))
        completePath.addLineToPoint(CGPoint(x: 0, y: 0))
        completePath.addLineToPoint(CGPoint(x: sWidth, y: 0))
        completePath.addLineToPoint(CGPoint(x: sWidth, y: sHeight))
        completePath.addLineToPoint(CGPoint(x: 0, y: sHeight))
        completePath.closePath()
        return completePath
    }
    
    
    func fillAnimation(complete:(flag:Bool) -> Void) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation.fromValue = arcPathPre.CGPath
        animation.toValue   = arcPathStarting.CGPath
        animation.duration  = animationDuration
        
        let lowAnimation:CABasicAnimation = CABasicAnimation(keyPath: "path")
        lowAnimation.fromValue = arcPathStarting.CGPath
        lowAnimation.toValue   = arcPathLow.CGPath
        lowAnimation.beginTime = animation.beginTime + animation.duration
        lowAnimation.duration  = animationDuration
        
        let highAnimation:CABasicAnimation = CABasicAnimation(keyPath: "path")
        highAnimation.fromValue = arcPathLow.CGPath
        highAnimation.toValue   = arcPathHigh.CGPath
        highAnimation.beginTime = lowAnimation.beginTime + lowAnimation.duration
        highAnimation.duration  = animationDuration
        
        let midAnimation:CABasicAnimation = CABasicAnimation(keyPath: "path")
        midAnimation.fromValue = arcPathHigh.CGPath
        midAnimation.toValue   = arcPathMid.CGPath
        midAnimation.beginTime = highAnimation.beginTime + highAnimation.duration
        midAnimation.duration  = animationDuration
        
        let completeAnimation:CABasicAnimation = CABasicAnimation(keyPath: "path")
        completeAnimation.fromValue = arcPathMid.CGPath
        completeAnimation.toValue   = arcPathComplete.CGPath
        completeAnimation.beginTime = midAnimation.beginTime + midAnimation.duration
        completeAnimation.duration  = animationDuration
        
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations = [animation,lowAnimation,highAnimation,midAnimation,completeAnimation]
        animationGroup.duration   = completeAnimation.beginTime + completeAnimation.duration
        animationGroup.fillMode   = kCAFillModeForwards
        animationGroup.delegate   = self
        animationGroup.removedOnCompletion = false
        addAnimation(animationGroup, forKey: nil)
        
        self.completeHandler = complete
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if self.completeHandler != nil {
            self.completeHandler!(flag:flag)
        }
    }
}
