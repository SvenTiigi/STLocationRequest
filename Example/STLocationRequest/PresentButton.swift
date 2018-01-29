//
//  PresentButton.swift
//  STLocationRequest_Example
//
//  Created by Sven Tiigi on 29.01.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class PresentButton: UIButton {
    
    // MARK: Properties
    
    /// The highlighted background color
    private var highlightedBackgroundColor: UIColor = .main
    
    // MARK: Initializer
    
    /// Convenience initializer
    convenience init(title: String) {
        self.init(type: .custom)
        self.setTitle(title, for: .normal)
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textColor = .main
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.main.cgColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.setTitleColor(.main, for: .normal)
        self.setTitleColor(.white, for: .highlighted)
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
