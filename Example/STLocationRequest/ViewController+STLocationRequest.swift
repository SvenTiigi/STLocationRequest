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
    func presentLocationRequestController(){
        // Initialize STLocationRequestController with Configuration
        let locationRequestController = STLocationRequestController { config in
            // Perform configuration
            config.titleText = "We need your location for some awesome features"
            config.allowButtonTitle = "Alright"
            config.notNowButtonTitle = "Not now"
            config.mapViewAlpha = 0.9
            config.backgroundColor = UIColor.lightGray
            config.authorizeType = .requestWhenInUseAuthorization
        }
        
        // Listen on STLocationRequestController.Event's
        locationRequestController.onEvent = { event in
            print("Retrieved STLocationRequestController.Event: \(event)")
            switch event {
            case .locationRequestAuthorized:
                print("The user accepted the use of location services")
                self.locationManager.startUpdatingLocation()
                break
            case .locationRequestDenied:
                print("The user denied the use of location services")
                break
            case .notNowButtonTapped:
                print("The Not now button was tapped")
                break
            case .didPresented:
                print("STLocationRequestController did presented")
                break
            case .didDisappear:
                print("STLocationRequestController did disappear")
                break
            }
        }
        
        // Present STLocationRequestController
        locationRequestController.present(onViewController: self)
    }
    
}
