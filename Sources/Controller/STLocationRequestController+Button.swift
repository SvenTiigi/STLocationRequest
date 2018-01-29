//
//  STLocationRequestController+Button.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 22.01.18.
//

import UIKit

extension STLocationRequestController {
    
    /// Custom UIButton for STLocationRequestController
    class Button: UIButton {
        
        // MARK: Properties
        
        /// The highlighted background color
        private var highlightedBackgroundColor: UIColor = .white
        
        // MARK: Initializer
        
        /// Convenience initializer to instantiate a STLocationRequest button
        ///
        /// - Parameters:
        ///   - title: The title
        ///   - font: The font
        ///   - target: The target
        ///   - action: The action
        convenience init(title: String, font: UIFont, highlightedBackgroundColor: UIColor, highlightedTitleColor: UIColor,  target: Any?, action: Selector) {
            self.init(type: .custom)
            self.highlightedBackgroundColor = highlightedBackgroundColor
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
            self.setTitleColor(highlightedTitleColor, for: .highlighted)
        }
        
        // MARK: ViewLifecycle
        
        override func layoutSubviews() {
            super.layoutSubviews()
            // Check if current background image is nil
            if self.currentBackgroundImage == nil {
                // Set the backgroundimage
                self.setBackgroundImage(
                    self.getImageWithColor(
                        self.highlightedBackgroundColor,
                        size: self.bounds.size
                    ),
                    for: .highlighted
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
    
}
