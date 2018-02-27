//
//  ViewController+STLocationRequest.swift
//  STLocationRequest_Example
//
//  Created by Sven Tiigi on 02.12.15.
//

import UIKit
import STLocationRequest

// MARK: STLocationRequestController

extension ViewController {
    
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
        
        // Listen on STLocationRequestController.Event's
        locationRequestController.onEvent = self.onEvent
        
        // Present STLocationRequestController
        locationRequestController.present(onViewController: self)
        
    }
    
    /// On STLocationRequestController.Event
    ///
    /// - Parameter event: The Event
    private func onEvent(_ event: STLocationRequestController.Event) {
        print("Retrieved STLocationRequestController.Event: \(event)")
        switch event {
        case .locationRequestAuthorized:
            print("The user accepted the use of location services")
            self.locationManager.startUpdatingLocation()
        case .locationRequestDenied:
            print("The user denied the use of location services")
        case .notNowButtonTapped:
            print("The Not now button was tapped")
        case .didPresented:
            print("STLocationRequestController did presented")
        case .didDisappear:
            print("STLocationRequestController did disappear")
        }
    }
    
}
