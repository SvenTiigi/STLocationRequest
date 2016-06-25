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

class ViewController: UIViewController, CLLocationManagerDelegate, STLocationRequestDelegate {
    
    // Storyboard IBOutlet for the Request Location Button
    @IBOutlet weak var requestLocationButton: UIButton!
    
    // Initialize CLLocationManager
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the locationManager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter=kCLDistanceFilterNone
    }
    
    // requestLocationButtonTouched Method
    @IBAction func requestLocationButtonTouched(sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .Denied {
                // Location Services are Denied
                print("Location Services are denied")
            } else {
                if CLLocationManager.authorizationStatus() == .NotDetermined{
                    // The user has never been asked about his location show the locationRequest Screen
                    // Just play around with the setMapViewAlphaValue and setBackgroundViewColor parameters, to match with your design of your app
                    // Also you can initialize an STLocationRequest Object and set all attributes
                    // and at the end call presentLocationRequestController
                    let locationRequest = STLocationRequest()
                    locationRequest.titleText = "We need your location for some awesome features"
                    locationRequest.allowButtonTitle = "Alright"
                    locationRequest.notNowButtonTitle = "Not now"
                    locationRequest.mapViewAlphaValue = 0.9
                    locationRequest.backgroundColor = UIColor.lightGrayColor()
                    locationRequest.authorizeType = .RequestWhenInUseAuthorization
                    locationRequest.delegate = self
                    locationRequest.pulseEffectEnabled = true
                    locationRequest.locationSymbolHidden = false
                    locationRequest.presentLocationRequestController(onViewController: self)
                } else {
                    // The user has already allowed your app to use location services
                    self.startUpdatingLocation()
                }
            }
        } else {
            // Location Services are disabled
            print("Location Services are disabled")
        }
    }

    // STLocationRequest Delegate Methods
    func locationRequestControllerDidChange(event: STLocationRequestEvent) {
        switch event {
        case .LocationRequestAuthorized:
            print("The user accepted the use of location services")
            self.startUpdatingLocation()
            break
        case .LocationRequestDenied:
            print("The user denied the use of location services")
            break
        case .NotNowButtonTapped:
            print("The Not now button was tapped")
            break
        case .LocationRequestDidPresented:
            print("STLocationRequestController did presented")
            break
        case .LocationRequestDidDisappear:
            print("STLocationRequestController did disappear")
            break
        }
    }
    
    // Start updating user location
    func startUpdatingLocation(){
        self.locationManager.startUpdatingLocation()
        print("Location service is allowed by the user. You have now access to the user location")
    }
    
    // CLLocationManagerDelegate Methods
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("The Location couldn't be found")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        print("didUpdateLocations UserLocation: \(locations.last)")
        
    }
    
}