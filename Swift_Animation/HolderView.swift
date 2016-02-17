//
//  HolderView.swift
//  Swift_Animation
//
//  Created by coder on 16/2/15.
//  Copyright © 2016年 coder. All rights reserved.
//

import UIKit

protocol HolderViewDelegate: NSObjectProtocol {
    func holderViewAnimationDidStop()
}

class HolderView: UIView {

    var ovalLayer:OvalLayer = OvalLayer()
    var triangleLayer:TriangleLayer = TriangleLayer()
    var redRectLayer:RectangleLayer?
    var blueRectLayer:RectangleLayer?
    var arcLayer:ArcLayer?
    var parentFrame:CGRect = CGRectZero
    weak var delegate:HolderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let aBounds:CGRect = CGRectMake(0, 0, frame.width, frame.height)
        redRectLayer  = RectangleLayer(bounds:aBounds)
        blueRectLayer = RectangleLayer(bounds:aBounds)
        arcLayer = ArcLayer(bounds:aBounds)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addOval() {
        self.layer.addSublayer(ovalLayer)
        ovalLayer.expand()
    }
    
    func addTriangleLayer() {
        self.layer.addSublayer(triangleLayer)
        NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: "animation", userInfo: nil, repeats: false)
        
    }
    
    func wobble() {
        ovalLayer.wobble {[weak self] (finish) -> () in
            if finish {
                if let s = self {
                    let duration:NSTimeInterval = 0.3
                    let rotateAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                    rotateAnimation.fromValue = CGFloat(0)
                    rotateAnimation.toValue   = CGFloat(M_PI * 2)
                    rotateAnimation.duration  = duration
                    rotateAnimation.delegate  = self
                    rotateAnimation.cumulative = true
                    rotateAnimation.removedOnCompletion = true
                    s.layer.addAnimation(rotateAnimation, forKey: "OvalLayerAnimation")
                    s.ovalLayer.ovalFadeAway(duration)
                }
            }
        }

    }

    func animation() {
        triangleLayer.animation()
    }
    
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool){
        if let rectangle = redRectLayer {
            self.layer.addSublayer(rectangle)
            rectangle.drawRedLine({ (flag) -> Void in
                if flag {
                    if let blueRect = self.blueRectLayer {
                        self.layer.addSublayer(blueRect)
                        blueRect.drawBlueLine({ (flag) -> Void in
                            if flag {
                                if let arc = self.arcLayer {
                                    self.layer.addSublayer(arc)
                                    arc.fillAnimation({ (flag) -> Void in
                                        self.expandView()
                                    })
                                }
                            }
                        })
                    }
                }
            })
        }
    }
    
    func expandView() {
        if let bl = blueRectLayer {
            backgroundColor = UIColor(CGColor: bl.endColor);
            frame = CGRect(x: frame.origin.x - bl.lineWidth,
                           y: frame.origin.y - bl.lineWidth,
                           width: frame.width + bl.lineWidth * 2,
                           height: frame.height + bl.lineWidth * 2)
            layer.sublayers = nil
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.frame = self.parentFrame
                }, completion: { (finish) -> Void in
                    let lag:Bool = (self.delegate?.respondsToSelector(Selector("holderViewAnimationDidStop")))!
                    if lag {
                        self.delegate?.holderViewAnimationDidStop()
                    }
            })
        }
    }
    
}
