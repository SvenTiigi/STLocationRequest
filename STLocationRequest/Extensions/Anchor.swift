//
//  Anchor.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 25.10.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

protocol Anchor {
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    
    var heightAnchor: NSLayoutDimension { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    
}

extension UIView: Anchor {}

extension UILayoutGuide: Anchor {}

extension UIViewController {
    
    var anchor: Anchor {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide
        } else {
            return self.view
        }
    }
    
}
