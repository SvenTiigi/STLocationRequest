//
//  STLocationRequestButton.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 18.11.17.
//

import UIKit

/// Custom UIButton for STLocationRequestController
public class STLocationRequestButton: UIButton {
    
    // MARK: Initializer
    
    /// Convenience initializer to instantiate a STLocationRequest button
    ///
    /// - Parameters:
    ///   - title: The title
    ///   - font: The font
    ///   - target: The target
    ///   - action: The action
    public convenience init(title: String, font: UIFont, target: Any?, action: Selector) {
        self.init(type: .custom)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textColor = .white
        self.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        self.addTarget(target, action: action, for: .touchUpInside)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.setTitleColor(UIColor.clear.withAlphaComponent(0.5), for: UIControlState.highlighted)
    }
    
    // MARK: ViewLifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // Check if current background image is nil
        if self.currentBackgroundImage == nil {
            // Set the backgroundimage
            self.setBackgroundImage(
                self.getImageWithColor(
                    UIColor.white,
                    size: self.bounds.size
                ),
                for: UIControlState.highlighted
            )
        }
    }
    
    // MARK: Helper functions
    
    /// Return a UIImage with a given UIColor and CGSize
    ///
    /// - Parameters:
    ///   - color: The color of the returned UIImage
    ///   - size: The size of the returned UIImage
    /// - Returns: Optional UIImage
    private func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
