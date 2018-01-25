//
//  ViewController.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 12/03/2015.
//  Copyright (c) 2015 Sven Tiigi. All rights reserved.
//

import UIKit
import CoreLocation
import STLocationRequest

/// Example application ViewController to present the STLocationRequestController
class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    /// Storyboard IBOutlet for the Request Location Button
    @IBOutlet weak var requestLocationButton: UIButton!
    
    // MARK: - Properties
    
    /// Initialize CLLocationManager
    let locationManager = CLLocationManager()
    
    // MARK: - View-Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Intialize the locationManager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
    }
    
    // MARK: - IBActions
    
    /// requestLocationButtonTouched Method
    @IBAction func requestLocationButtonTouched(_ sender: UIButton) {
        self.presentLocationRequestController()
    }
    
    // MARK: - Present STLocationRequestController
    
    /// Initialize and present STLocationRequestController
    func presentLocationRequestController(){
        // Initialize STLocationRequestController with Configuration
        let locationRequestController = STLocationRequestController { (config) in
            config.titleText = "We need your location for some awesome features"
            config.allowButtonTitle = "Alright"
            config.notNowButtonTitle = "Not now"
            config.mapViewAlpha = 0.9
            config.backgroundColor = UIColor.lightGray
            config.authorizeType = .requestWhenInUseAuthorization
        }
        // Get notified on STLocationRequestController.Events
        locationRequestController.onChange = self.locationRequestControllerOnChange
        // Present STLocationRequestController
        locationRequestController.present(onViewController: self)
    }
    
    func locationRequestControllerOnChange(event: STLocationRequestController.Event) {
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

}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    /// CLLocationManagerDelegate DidFailWithError Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error. The Location couldn't be found. \(error)")
    }
    
    /// CLLocationManagerDelegate didUpdateLocations Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        print("didUpdateLocations UserLocation: \(String(describing: locations.last))")
    }
    
}
