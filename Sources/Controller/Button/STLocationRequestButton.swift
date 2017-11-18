//
//  STLocationRequestButton.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 18.11.17.
//

import UIKit

public class STLocationRequestButton: UIButton {
    
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if self.currentBackgroundImage == nil {
            self.setBackgroundImage(self.getImageWithColor(UIColor.white, size: self.bounds.size), for: UIControlState.highlighted)
        }
        
    }
    
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
