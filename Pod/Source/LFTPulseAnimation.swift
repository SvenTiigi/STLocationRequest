//
//  LFTPulseAnimation.swift
//
//  Created by Christoffer Tews on 18.12.14.
//  Copyright (c) 2014 Christoffer Tews. All rights reserved.
//
//  Swift clone of: https://github.com/shu223/PulsingHalo/blob/master/PulsingHalo/PulsingHaloLayer.m

import UIKit

class LFTPulseAnimation: CALayer {
   
    var radius:                 CGFloat = 200.0
    var fromValueForRadius:     Float = 0.0
    var fromValueForAlpha:      Float = 0.45
    var keyTimeForHalfOpacity:  Float = 0.2
    var animationDuration:      NSTimeInterval = 3.0
    var pulseInterval:          NSTimeInterval = 0.0
    var useTimingFunction:      Bool = true
    var animationGroup:         CAAnimationGroup = CAAnimationGroup()
    var repetitions:            Float = Float.infinity

    // Need to implement that, because otherwise it can't find
    // the constructor init(layer:AnyObject!)
    // Doesn't seem to look in the super class
    override init(layer: AnyObject) {
        super.init(layer: layer)
    }
    
    init(repeatCount: Float=Float.infinity, radius: CGFloat, position: CGPoint) {
        super.init()
        self.contentsScale = UIScreen.mainScreen().scale
        self.opacity = 0.0
        self.backgroundColor = UIColor.blueColor().CGColor
        self.radius = radius;
        self.repetitions = repeatCount;
        self.position = position
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            self.setupAnimationGroup()
            self.setPulseRadius(self.radius)
            
            if (self.pulseInterval != Double.infinity) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.addAnimation(self.animationGroup, forKey: "pulse")
                })
            }
        })
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPulseRadius(radius: CGFloat) {
        self.radius = radius
        let tempPos = self.position
        let diameter = self.radius * 2
        
        self.bounds = CGRect(x: 0.0, y: 0.0, width: diameter, height: diameter)
        self.cornerRadius = self.radius
        self.position = tempPos
    }
    
    func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = self.animationDuration + self.pulseInterval
        self.animationGroup.repeatCount = self.repetitions
        self.animationGroup.removedOnCompletion = false
        
        if self.useTimingFunction {
            let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
            self.animationGroup.timingFunction = defaultCurve
        }
        
        self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
    }
    
    func createScaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(float: self.fromValueForRadius)
        scaleAnimation.toValue = NSNumber(float: 1.0)
        scaleAnimation.duration = self.animationDuration
        
        return scaleAnimation
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = self.animationDuration
        opacityAnimation.values = [self.fromValueForAlpha, 0.8, 0]
        opacityAnimation.keyTimes = [0, self.keyTimeForHalfOpacity, 1]
        opacityAnimation.removedOnCompletion = false
        
        return opacityAnimation
    }
    
}
