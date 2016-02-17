//
//  OvalLayer.swift
//  Swift_Animation
//
//  Created by coder on 16/2/15.
//  Copyright © 2016年 coder. All rights reserved.
//

import UIKit


class OvalLayer: CAShapeLayer {

    let animationDuration:NSTimeInterval = 0.3;
    var animationComplete:((finish:Bool) -> ())?;
    
    override init() {
        super.init();
        fillColor   = UIColor.redColor().CGColor
        strokeColor = UIColor.clearColor().CGColor
        position = CGPoint(x: 0.5, y: 0.5)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        lineWidth   = 0
        path = ovalPathSmall.CGPath
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var ovalPathSmall: UIBezierPath {
        return UIBezierPath(ovalInRect: CGRect(x: 50.0, y: 50.0, width: 0.0, height: 0.0))
    }
    
    var ovalPathLarge: UIBezierPath {
        return UIBezierPath(ovalInRect: CGRect(x: 2.5, y: 17.5, width: 95.0, height: 95.0))
    }
    
    var ovalPathSquishHorizontal: UIBezierPath {
        return UIBezierPath(ovalInRect: CGRect(x: 2.5, y: 20.0, width: 95.0, height: 90.0))
    }
    
    var ovalPathSquishVertical: UIBezierPath {
        return UIBezierPath(ovalInRect: CGRect(x: 5.0, y: 20.0, width: 90.0, height: 90.0))
    }
    
    func expand() {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation.fromValue = ovalPathSmall.CGPath
        animation.toValue = ovalPathLarge.CGPath
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.duration = 3
        addAnimation(animation, forKey: "animationPath")
    }
    
    
    func wobble(complete:(finish:Bool) -> ()) {
        let animation1:CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation1.fromValue = ovalPathLarge.CGPath
        animation1.toValue   = ovalPathSquishVertical.CGPath
        animation1.duration  = animationDuration
        
        let animation2:CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation2.fromValue = ovalPathSquishVertical.CGPath
        animation2.toValue   = ovalPathSquishHorizontal.CGPath
        animation2.beginTime = animation1.beginTime + animation1.duration
        animation2.duration  = animationDuration
        
        let animation3:CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation3.fromValue = ovalPathSquishHorizontal.CGPath
        animation3.toValue   = ovalPathSquishVertical.CGPath
        animation3.beginTime = animation2.beginTime + animation2.duration
        animation3.duration  = animationDuration
        
        let animation4:CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation4.fromValue = ovalPathSquishVertical.CGPath
        animation4.toValue   = ovalPathLarge.CGPath
        animation4.beginTime = animation3.beginTime + animation3.duration
        animation4.duration  = animationDuration
        
        let animationGroup:CAAnimationGroup = CAAnimationGroup()
        animationGroup.animations  = [animation1,animation2,animation3,animation4]
        animationGroup.beginTime   = CACurrentMediaTime();
        animationGroup.duration    = animation4.beginTime + animation4.duration
        animationGroup.repeatCount = 2
        animationGroup.delegate    = self
        animationGroup.fillMode  = kCAFillModeForwards
        animationGroup.removedOnCompletion = false
        addAnimation(animationGroup, forKey: nil)
        
        self.animationComplete = complete;
    }
    
    func ovalFadeAway(duration:NSTimeInterval) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation.fromValue = ovalPathLarge.CGPath
        animation.toValue   = ovalPathSmall.CGPath
        animation.fillMode  = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.duration  = duration
        addAnimation(animation, forKey: nil)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if self.animationComplete != nil {
            self.animationComplete!(finish: flag);
        }
    }
}
