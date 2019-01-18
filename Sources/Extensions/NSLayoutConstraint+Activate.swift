//
//  NSLayoutConstraint+Activate.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 25.10.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit

// MARK: - NSLayoutConstraint+Activate

extension NSLayoutConstraint {
    
    /// Activate on View
    ///
    /// - Parameters:
    ///   - view: The View
    ///   - constraints: The Constraints
    static func activate(on view: UIView, _ constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.activate(constraints)
    }
    
}
