//
//  Anchor.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 25.10.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit

// MARK: - Anchor

/// The Anchor Protocol
protocol Anchor {
    
    /// The Top Anchor
    var topAnchor: NSLayoutYAxisAnchor { get }
    
    /// The Bottom Anchor
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    
    /// The Leading Anchor
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    
    /// The Trailing Anchor
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    /// The Width Anchor
    var widthAnchor: NSLayoutDimension { get }
    
    /// The Height Anchor
    var heightAnchor: NSLayoutDimension { get }
    
    /// The center x anchor
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    
    /// The center y anchor
    var centerYAnchor: NSLayoutYAxisAnchor { get }
    
}

// MARK: - UIView+Anchor

extension UIView: Anchor {}

// MARK: - UILayoutGuide+Anchor

extension UILayoutGuide: Anchor {}

// MARK: - UIViewController+Anchor

extension UIViewController {
    
    /// The Anchor
    var anchor: Anchor {
        #if os(iOS)
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide
        } else {
            return self.view
        }
        #elseif os(tvOS)
        if #available(tvOS 11.0, *) {
            return self.view.safeAreaLayoutGuide
        } else {
            return self.view
        }
        #else
        return self.view
        #endif
    }
    
}
