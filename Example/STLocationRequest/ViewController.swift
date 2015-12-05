//
//  ViewController.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 12/03/2015.
//  Copyright (c) 2015 Sven Tiigi. All rights reserved.
//

import UIKit
import STLocationRequest
import CoreLocation
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    
    // Storyboard IBOutlet for the Request Location Button
    @IBOutlet weak var requestLocationButton: UIButton!
    // Initialize CLLocationManager
    var locationManager = CLLocationManager()
    // Storyboard IBOutlet
    @IBOutlet weak var addressLabel: UILabel!
    // Storyboard IBOutlet MapView
    @IBOutlet weak var mapView: MKMapView!
    /*
    viewDidLoad Method
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate for the MapView
        self.mapView.delegate = self
        self.mapView.layer.cornerRadius = 5.0
        
        // Get a nice looking UIButton
        self.setCustomButtonStyle(self.requestLocationButton)
        
        // Set the locationManager
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter=kCLDistanceFilterNone
        
        // Add the NotificationCenter Observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestNotNow", name: "locationRequestNotNow", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestAuthorized", name: "locationRequestAuthorized", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestDenied", name: "locationRequestDenied", object: nil)
    }
    
    /*
    requestLocationButtonTouched Method
    */
    @IBAction func requestLocationButtonTouched(sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .Denied{
                // Location Services are Denied
            }else{
                if CLLocationManager.authorizationStatus() == .NotDetermined{
                    // The user has never been asked about his location show the locationRequest Screen
                    // Just play around with the setMapViewAlphaValue and setBackgroundViewColor parameters, to match with your design of your app
                    self.showLocationRequestController(setTitle: "We need your location for some awesome features", setAllowButtonTitle: "Alright", setNotNowButtonTitle: "Not now", setMapViewAlphaValue: 0.7, setBackgroundViewColor: UIColor.lightGrayColor())
                }else{
                    // The user has already allowed your app to use location services
                    if #available(iOS 9.0, *) {
                        self.locationManager.requestLocation()
                    } else {
                        self.locationManager.startUpdatingLocation()
                    }
                }
            }
        }else{
            // Location Services are disabled
        }
    }
    
    /*
    STLocationRequest NotificationCenter Methods
    */
    func locationRequestNotNow(){
        print("The user cancled the locationRequestScreen")
    }
    func locationRequestAuthorized(){
        if #available(iOS 9.0, *) {
            self.locationManager.requestLocation()
        } else {
            self.locationManager.startUpdatingLocation()
        }
        print("Location service is allowed by the user. You have now access to the user location")
    }
    func locationRequestDenied(){
        print("Location service is denied by the user")
    }
    
    /*
    CLLocationManagerDelegate Methods
    */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("The Location couldn't be found")
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let geoCoder = CLGeocoder()
        guard let userLocation = locations.last else{
            return
        }
        self.mapView.showsUserLocation = true
        geoCoder.reverseGeocodeLocation(userLocation) { (placemarks, error) -> Void in
            guard let placemark = placemarks?.last else{
                return
            }
            var thoroughfare = ""
            var subThoroughfare = ""
            var postalCode = ""
            var locality = ""
            if let optThoroughfare = placemark.thoroughfare {
                thoroughfare = optThoroughfare + " "
            }
            if let optSubThorughfare = placemark.subThoroughfare{
                subThoroughfare = " " + optSubThorughfare + " "
            }
            if let optPostalCode = placemark.postalCode{
                postalCode = " " + optPostalCode + " "
            }
            if let optLocality = placemark.locality{
                locality = " " + optLocality
            }
            UIView.animateWithDuration(0.8, animations: { () -> Void in
                self.mapView.alpha = 0
                self.addressLabel.text = "\(thoroughfare)\(subThoroughfare)\(postalCode)\(locality)"
                self.mapView.alpha = 1
            })
        }
    }
    
    /*
    Delegate Method didUpdateUserLocation for the MapView to zoom in to the user location
    */
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        self.mapView.showAnnotations([self.mapView.userLocation], animated: true)
    }
    
    /*
    #######
    These are just Method for a nice UIButton :)
    #######
    */
    
    /*
    Set a custom style for a given UIButton
    */
    private func setCustomButtonStyle(button : UIButton){
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.orangeColor().CGColor
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        button.setBackgroundImage(getImageWithColor(UIColor.orangeColor(), size: button.bounds.size), forState: UIControlState.Highlighted)
    }
    
    /*
    Return a UIImage with a given UIColor and CGSize
    */
    private func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

