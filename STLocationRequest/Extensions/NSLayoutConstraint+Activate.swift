//
//  NSLayoutConstraint+Activate.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 25.10.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    
    static func activate(on view: UIView, _ constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.activate(constraints)
    }
    
}
