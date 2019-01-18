//
//  ViewController.swift
//  Example-tvOS
//
//  Created by Sven Tiigi on 18.01.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import STLocationRequest
import UIKit

/// The ViewController
class ViewController: UIViewController {
    
    // MARK: View-Lifecycle
    
    /// View did appear
    ///
    /// - Parameter animated: If animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presentLocationRequestController()
    }
    
    // MARK: STLocationRequest
    
    /// Present the STLocationRequestController
    func presentLocationRequestController() {
        
        // Initialize STLocationRequestController with Configuration
        let locationRequestController = STLocationRequestController { config in
            // Perform configuration
            config.title.text = "We need your location for some awesome features"
            config.allowButton.title = "Alright"
            config.notNowButton.title = "Not now"
            config.mapView.alpha = 0.9
            config.backgroundColor = UIColor.lightGray
            config.authorizeType = .requestWhenInUseAuthorization
        }
        
        // Present STLocationRequestController
        locationRequestController.present(onViewController: self)
        
    }
    
}

