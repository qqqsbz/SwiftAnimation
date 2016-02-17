//
//  ViewController.swift
//  Swift_Animation
//
//  Created by coder on 16/2/15.
//  Copyright © 2016年 coder. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,HolderViewDelegate{

    var holderView:HolderView?
    let boxSize:CGFloat = 100.0;
    override func viewDidLoad() {
        super.viewDidLoad()
        holderView = HolderView(frame: CGRect(x: self.view.center.x - boxSize / 2, y: self.view.center.y - boxSize / 2, width: boxSize, height: boxSize))
        holderView?.parentFrame = self.view.frame
        holderView!.addOval()
        holderView!.addTriangleLayer()
        holderView?.delegate = self
        view.addSubview(self.holderView!);
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "wobble", userInfo: nil, repeats: false)
    }

    func wobble() {
        holderView!.wobble()
    }

    func holderViewAnimationDidStop() {
        let label:UILabel = UILabel(frame: CGRect(x: self.view.center.x - boxSize / 4, y: self.view.center.y - boxSize / 4, width: boxSize / 2, height: boxSize / 2))
        label.textColor = UIColor.whiteColor()
        label.text = "S"
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 60.0)
        label.textAlignment = NSTextAlignment.Center
        label.transform = CGAffineTransformScale(label.transform, 0.25, 0.25)
        self.view.addSubview(label)
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            label.transform = CGAffineTransformScale(label.transform, 8.0, 8.0)
            }) { (finish) -> Void in
                
        }
    }

}

