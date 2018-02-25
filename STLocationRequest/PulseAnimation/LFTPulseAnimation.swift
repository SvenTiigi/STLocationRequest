//
//  LFTPulseAnimation.swift
//
//  Created by Christoffer Tews on 18.12.14.
//  Copyright (c) 2014 Christoffer Tews. All rights reserved.
//
//  Swift clone of: https://github.com/shu223/PulsingHalo/blob/master/PulsingHalo/PulsingHaloLayer.m

import UIKit

/// The LFTPulseAnimation for displaying an pulse effect
class LFTPulseAnimation: CALayer {
    
    // MARK: Properties
    
    /// The radius
    var radius: CGFloat = 200.0
    
    /// FromValue Radius
    var fromValueForRadius: Float = 0.0
    
    /// FromValue Alpha
    var fromValueForAlpha: Float = 0.45
    
    /// keyTime Half Opacity
    var keyTimeForHalfOpacity: Float = 0.2
    
    /// The animation duration
    var animationDuration: TimeInterval = 3.0
    
    /// The interval
    var pulseInterval: TimeInterval = 0.0
    
    /// Use Timing Function Boolean
    var useTimingFunction = true
    
    /// The animation group
    var animationGroup = CAAnimationGroup()
    
    /// Repetitions
    var repetitions = Float.infinity
    
    // MARK: Initializer
    
    /// Need to implement that, because otherwise it can't find
    /// the constructor init(layer:AnyObject!)
    /// Doesn't seem to look in the super class
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    /// Default initializer
    ///
    /// - Parameters:
    ///   - repeatCount: The repeat count
    ///   - radius: The radius
    ///   - position: The position
    init(repeatCount: Float = Float.infinity, radius: CGFloat, position: CGPoint) {
        super.init()
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0.0
        self.backgroundColor = UIColor.blue.cgColor
        self.radius = radius
        self.repetitions = repeatCount
        self.position = position
        DispatchQueue.global(qos: .background).async {
            self.setupAnimationGroup()
            self.setPulseRadius(self.radius)
            if self.pulseInterval != Double.infinity {
                DispatchQueue.main.async(execute: {
                    self.add(self.animationGroup, forKey: "pulse")
                })
            }
        }
    }
    
    /// Initializer with NSCoder. Unsupported will return nil
    ///
    /// - Parameter aDecoder: The decoder
    required init?(coder aDecoder: NSCoder) {
        // Return nil
        return nil
    }
    
    // MARK: Public API
    
    /// Set Pulse Radius
    ///
    /// - Parameter radius: The radius
    func setPulseRadius(_ radius: CGFloat) {
        self.radius = radius
        let tempPos = self.position
        let diameter = self.radius * 2
        self.bounds = CGRect(x: 0.0, y: 0.0, width: diameter, height: diameter)
        self.cornerRadius = self.radius
        self.position = tempPos
    }
    
    // MARK: Private API
    
    /// Setup Animation Group
    private func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = self.animationDuration + self.pulseInterval
        self.animationGroup.repeatCount = self.repetitions
        self.animationGroup.isRemovedOnCompletion = false
        if self.useTimingFunction {
            let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
            self.animationGroup.timingFunction = defaultCurve
        }
        self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
    }
    
    /// Create Scale Animation
    private func createScaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: self.fromValueForRadius as Float)
        scaleAnimation.toValue = NSNumber(value: 1.0 as Float)
        scaleAnimation.duration = self.animationDuration
        return scaleAnimation
    }
    
    /// Create Opacity Animation
    private func createOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = self.animationDuration
        opacityAnimation.values = [self.fromValueForAlpha, 0.8, 0]
        opacityAnimation.keyTimes = [0, NSNumber(value: self.keyTimeForHalfOpacity), 1]
        opacityAnimation.isRemovedOnCompletion = false
        return opacityAnimation
    }
    
}
