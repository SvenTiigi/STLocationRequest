//
//  STLocationRequestController.swift
//  Pods
//
//  Created by Sven Tiigi on 02.12.15.
//
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import Font_Awesome_Swift


public class STLocationRequestController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // Storyboard IBOutlets
    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationSymbolLabel: UILabel!
    // CitryCoordinate which store all coordinates
    var cityCoordinates: [CLLocationCoordinate2D] = []
    // tempRandom & random to select a random coordinate
    var tempRandom = 0
    var random = 0
    // Initialize STRotatingCamera
    var rotatingCamera = STRotatingCamera()
    // Initialize CLLocationManager
    var locationManager = CLLocationManager()
    var pulseEffect = LFTPulseAnimation(radius: 0, position: CGPointMake(0,0))
    // Variables for UILabel and UIButton
    public var titleLabelText = String()
    public var allowButtonTitle = String()
    public var notNowButtonTitle = String()
    // Variables for appearance
    public var mapViewAlphaValue = CGFloat()
    public var backgroundViewColor = UIColor()

    /*
        viewDidLoad Method
    */
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the text for UILabel and UIButtons
        self.descriptionLabel.text = self.titleLabelText
        self.allowButton.setTitle(allowButtonTitle, forState: UIControlState.Normal)
        self.notNowButton.setTitle(notNowButtonTitle, forState: UIControlState.Normal)
        // Setting the Background Color and Alpha Value for the map
        self.mapView.alpha = self.mapViewAlphaValue
        self.view.backgroundColor = self.backgroundViewColor
        // Set the appearence of the mapView
        self.mapView.delegate = self
        self.mapView.zoomEnabled = false
        self.mapView.scrollEnabled = false
        self.mapView.userInteractionEnabled = false
        self.mapView.showsBuildings = true
        self.mapView.pitchEnabled = true
        // Check if SatelliteFlyover is avaible
        if #available(iOS 9.0, *) {
            self.mapView.mapType = .SatelliteFlyover
            self.mapView.showsCompass = false
            self.mapView.showsScale = false
        } else {
            self.mapView.mapType = .Satellite
        }
        // Set the Delegate of the locationManager
        self.locationManager.delegate = self
        // Set the location-symbol using fontAwesom
        self.locationSymbolLabel.setFAIcon(FAType.FALocationArrow, iconSize: 150)
        self.locationSymbolLabel.textColor = UIColor.whiteColor()
        // Set custom stlye to the UIButton
        self.setCustomButtonStyle(self.allowButton)
        self.setCustomButtonStyle(self.notNowButton)
        // Setting the Pulse Effect
        self.pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:180, position:self.view.center)
        self.pulseEffect.backgroundColor = UIColor.whiteColor().CGColor
        self.view.layer .insertSublayer(pulseEffect, below: self.locationSymbolLabel.layer)
        // Create a rotating camera object and pass a mapView
        self.rotatingCamera = STRotatingCamera(mapView: self.mapView)
        // Add standard city to cityArray
        self.addStandardCity()
        // Start the flyover Magic
        self.changeRandomFlyOverCity()
        // Start the timer for changing location even more magic here :)
        NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "changeRandomFlyOverCity", userInfo: nil, repeats: true)
    }
    
    /*
        If Device is going landscape hide the location symbol and the pulse layer
    */
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.locationSymbolLabel.alpha = 1
                self.locationSymbolLabel.alpha = 0
            })
            self.pulseEffect.setPulseRadius(0)
        } else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.locationSymbolLabel.alpha = 0
                self.locationSymbolLabel.alpha = 1
            })
            self.pulseEffect.setPulseRadius(180)
        }
    }
    
    /*
        CLLocationManager Delegate if the User allowed oder denied the location request
    */
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
            case .AuthorizedWhenInUse:
                NSNotificationCenter.defaultCenter().postNotificationName("locationRequestAuthorized", object: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
                break
            case .Denied:
                NSNotificationCenter.defaultCenter().postNotificationName("locationRequestDenied", object: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
                break
            default:
                break
        }
    }
    
    /*
        MKMapView Delegate regionDidChangeAnimated
    */
    public func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
       if (self.rotatingCamera.isStopped() == true) {
            self.rotatingCamera.continueRotating()
        }
    }
    
    /*
        Add citys to cityCoordinate Array
    */
    private func addStandardCity(){
        let eiffelTower = CLLocationCoordinate2DMake(48.85815,2.29452);
        let statueOfLiberty = CLLocationCoordinate2DMake(40.689249, -74.044500);
        let goldenGateBridge = CLLocationCoordinate2DMake(37.826040, -122.479448);
        let berlinBrandenburgerGate = CLLocationCoordinate2DMake(52.516275, 13.377704);
        let hamburgTownHall = CLLocationCoordinate2DMake(53.550416, 9.992527);
        let newYork = CLLocationCoordinate2DMake(40.702749, -74.014120);
        let cologneCathedral = CLLocationCoordinate2DMake(50.941278, 6.958281);
        let romKolluseum = CLLocationCoordinate2DMake(41.89021, 12.492231);
        let munichCurch = CLLocationCoordinate2DMake(48.138631, 11.573625);
        let neuschwansteinCastle = CLLocationCoordinate2DMake(47.557574, 10.749800);
        let londonBigBen = CLLocationCoordinate2DMake(51.500729, -0.124625);
        let londonEye = CLLocationCoordinate2DMake(51.503324, -0.119543);
        let sydneyOperaHouse = CLLocationCoordinate2DMake(-33.857197, 151.215140);
        self.cityCoordinates.append(eiffelTower)
        self.cityCoordinates.append(statueOfLiberty)
        self.cityCoordinates.append(goldenGateBridge)
        self.cityCoordinates.append(berlinBrandenburgerGate)
        self.cityCoordinates.append(hamburgTownHall)
        self.cityCoordinates.append(newYork)
        self.cityCoordinates.append(cologneCathedral)
        self.cityCoordinates.append(romKolluseum)
        self.cityCoordinates.append(munichCurch)
        self.cityCoordinates.append(neuschwansteinCastle)
        self.cityCoordinates.append(londonBigBen)
        self.cityCoordinates.append(londonEye)
        self.cityCoordinates.append(sydneyOperaHouse)
    }
    
    /*
        Set a custom style for a given UIButton
    */
    private func setCustomButtonStyle(button : UIButton){
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.clearColor().colorWithAlphaComponent(0.5), forState: UIControlState.Highlighted)
        button.setBackgroundImage(getImageWithColor(UIColor.whiteColor(), size: button.bounds.size), forState: UIControlState.Highlighted)
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
    
    /*
        Get a random City and change the location on the map
     */
    func changeRandomFlyOverCity(){
        repeat {
            self.random = Int(arc4random_uniform(UInt32(self.cityCoordinates.count)))
        } while (self.random == self.tempRandom)
        self.tempRandom = self.random
        UIView.animateWithDuration(0.5) { () -> Void in
            self.rotatingCamera.stopRotating()
            self.mapView.region = MKCoordinateRegionMakeWithDistance(self.cityCoordinates[self.random], 1000, 1000)
            //self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(self.cityCoordinates[self.random], 1000, 1000), animated: true)
            self.rotatingCamera.startRotatingWithCoordinate(self.cityCoordinates[self.random], heading: 45, pitch: 45, altitude: 500, headingStep: 10)
        }
    }
    
    /*
        Allow button was touched request authorization
    */
    @IBAction func allowButtonTouched(sender: UIButton) {
       self.locationManager.requestWhenInUseAuthorization()
    }
    
    /*
        Not now button was touched dismiss Viewcontroller
    */
    @IBAction func notNowButtonTouched(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("locationRequestNotNow", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
