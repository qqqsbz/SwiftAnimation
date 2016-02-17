//
//  RectangleLayer.swift
//  Swift_Animation
//
//  Created by coder on 16/2/16.
//  Copyright © 2016年 coder. All rights reserved.
//

import UIKit

class RectangleLayer: CAShapeLayer {

    var parentBounds:CGRect   = CGRectZero
    let rectLineWidth:CGFloat = 7
    let startColor:CGColorRef = UIColor.redColor().CGColor
    let endColor:CGColorRef   = UIColor(red: 60.0/255.0, green: 115.0/255.0, blue: 146.0/255.0, alpha: 1.0).CGColor
    let animationDuration:NSTimeInterval = 1.0
    var redCompleteHandler:((flag:Bool) -> Void)?
    var blueCompleteHandler:((flag:Bool) -> Void)?
    
    init(bounds:CGRect) {
        super.init();
        self.lineWidth    = rectLineWidth
        self.parentBounds = bounds;
        self.strokeStart  = 0.0
        self.strokeEnd    = 1.0
        self.fillColor    = UIColor.whiteColor().CGColor
        self.strokeColor  = self.startColor
        self.path         = rectangleLagerPath.CGPath
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rectangleLagerPath: UIBezierPath {
        let bezierPath = UIBezierPath();
        bezierPath.moveToPoint(CGPoint(x: 0, y: self.parentBounds.height))
        bezierPath.addLineToPoint(CGPoint(x: 0, y: 0))
        bezierPath.moveToPoint(CGPoint(x: 0, y: 0))
        bezierPath.addLineToPoint(CGPoint(x: self.parentBounds.width, y: 0))
        bezierPath.moveToPoint(CGPoint(x: self.parentBounds.width, y: 0))
        bezierPath.addLineToPoint(CGPoint(x: self.parentBounds.width, y: self.parentBounds.height))
        bezierPath.moveToPoint(CGPoint(x: self.parentBounds.width, y: self.parentBounds.height))
        bezierPath.addLineToPoint(CGPoint(x: -self.rectLineWidth / 2, y: self.parentBounds.height))
        return bezierPath;
    }
    
    func drawRedLine(complete:(flag:Bool) -> Void) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = CGFloat(0.0)
        animation.toValue   = CGFloat(1.0)
        animation.duration  = animationDuration
        animation.cumulative = true
        animation.fillMode  = kCAFillModeForwards
        animation.removedOnCompletion = false
        addAnimation(animation, forKey: nil)
        
        self.redCompleteHandler = complete;
        
        NSTimer.scheduledTimerWithTimeInterval(animationDuration / 4, target: self, selector: "animationDidStart", userInfo: nil, repeats: false)
    }
    
    func drawBlueLine(complete:(flag:Bool) -> Void) {
        let strokeColor:CABasicAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeColor.fromValue = self.startColor
        strokeColor.toValue   = self.endColor
        
        let strokeEnd:CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.fromValue = CGFloat(0.0)
        strokeEnd.toValue   = CGFloat(1.0)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [strokeColor,strokeEnd]
        animationGroup.beginTime  = CACurrentMediaTime()
        animationGroup.fillMode   = kCAFillModeForwards
        animationGroup.duration   = animationDuration
        animationGroup.removedOnCompletion = false
        animationGroup.delegate   = self
        addAnimation(animationGroup, forKey: nil)
        self.blueCompleteHandler = complete
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if self.blueCompleteHandler != nil {
            self.blueCompleteHandler!(flag: true)
        }
    }
    
    func animationDidStart() {
        if self.redCompleteHandler != nil {
            self.redCompleteHandler!(flag: true)
        }
    }
}
