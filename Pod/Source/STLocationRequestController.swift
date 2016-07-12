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

class STLocationRequestController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    /// IBOutlets connections
	@IBOutlet weak var allowButton: UIButton!
	@IBOutlet weak var notNowButton: UIButton!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var locationSymbolLabel: UILabel!
	
	/// CitryCoordinate which store all coordinates
	var cityOrLandmarks3DCoordinates: [CLLocationCoordinate2D] = []
	
	/// Array to store random integer values
    var randomNumbers: [Int] = []
	
	/// Initialize STRotatingCamera
	var rotatingCamera = STRotatingCamera()
	
	/// Initialize CLLocationManager
	var locationManager = CLLocationManager()
	var pulseEffect = LFTPulseAnimation(radius: 0, position: CGPointMake(0,0))
	
	/// Variables for UILabel and UIButton
    var titleLabelText = String()
    var allowButtonTitle = String()
    var notNowButtonTitle = String()
	
	/// Variables for appearance
    var mapViewAlphaValue : Double?
    var backgroundViewColor : UIColor?
    
    /// Variable for NSTimer
    var timer : NSTimer?
    
    /// Pulse-Effect enabled
    var pulseEffectEnabled = true

    /// Pulse-Effect backgroundcolor
    var pulseEffectColor = UIColor.whiteColor()
    
    /// Location symbol icon
    var locationSymbolIcon = FAType.FALocationArrow
    
    /// Location symbol color
    var locationSymbolColor = UIColor.whiteColor()
    
    // location symbol hidden
    var locationSymbolHidden = false
    
    /// Authorization Type
    var authorizeType : STLocationAuthorizeType?
    
    /// Delegate Object
    var delegate : STLocationRequestDelegate?

    /// viewDidLoad
    override func viewDidLoad() {
		super.viewDidLoad()
		
        // Set the text for Description and Button Labels
        self.setDescriptionAndButtonText()
        
        // Set the custom color scheme
        self.setColorScheme()
		
        // Set the settings for MKMapView
        self.setMapViewSettings()
	
		// Set the Delegate of the locationManager
		self.locationManager.delegate = self
		
		// Set the location-symbol using fontAwesom
        if !locationSymbolHidden {
            self.locationSymbolLabel.setFAIcon(locationSymbolIcon, iconSize: 150)
            self.locationSymbolLabel.textColor = locationSymbolColor
        }else{
            self.locationSymbolLabel.text = ""
        }
		
		// Set custom stlye to the UIButton
		self.setCustomButtonStyle(self.allowButton)
		self.setCustomButtonStyle(self.notNowButton)
		
        // Add the Pulse-Effect under the Location-Symbol
        if pulseEffectEnabled {
            self.addPulseEffect()
        }
        
		// Create a rotating camera object and pass a mapView
		self.rotatingCamera = STRotatingCamera(mapView: self.mapView)
		
		// Add standard city to cityArray
		self.fillCityOrLandmarks3DCoordinatesArray()
		
		// Start the flyover Magic
		self.changeRandomFlyOverCity()
		
		// Start the timer for changing location even more magic here :)
		self.timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: #selector(STLocationRequestController.changeRandomFlyOverCity), userInfo: nil, repeats: true)
	}
    
    /// Set the text for the description and button labels
    private func setDescriptionAndButtonText(){
        // Setting the text for UILabel and UIButtons
        self.descriptionLabel.text = self.titleLabelText
        self.allowButton.setTitle(allowButtonTitle, forState: UIControlState.Normal)
        self.notNowButton.setTitle(notNowButtonTitle, forState: UIControlState.Normal)
    }
	
    /// Set the color scheme to get a individual look and feel for the STLocationRequest Screen
    private func setColorScheme(){
        // Setting the alpha Value for MapView
        // If it's nil then alphaValue will be 1
        if let alphaValue = self.mapViewAlphaValue{
            self.mapView.alpha = CGFloat(alphaValue)
        }else{
            self.mapView.alpha = 1
        }
        // Setting the backgroundColor for UIView
        // If it's nil then backgroundColor will be white
        if let backgroundColor = self.backgroundViewColor {
            self.view.backgroundColor = backgroundColor
        }else{
            self.view.backgroundColor = UIColor.whiteColor()
        }
    }
    
    /// Set the specific MKMapView Settings
    private func setMapViewSettings(){
        // Check if SatelliteFlyover is avaible
        if #available(iOS 9.0, *) {
            self.mapView.mapType = .SatelliteFlyover
            self.mapView.showsCompass = false
            self.mapView.showsScale = false
        } else {
            self.mapView.mapType = .Satellite
        }
    }
    
    /// Adding the pulse effect under the Location-Symbol in the middle of the STLocationRequest Screen
    private func addPulseEffect(){
        // Setting the Pulse Effect
        self.pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:180, position:self.view.center)
        self.pulseEffect.backgroundColor = self.pulseEffectColor.CGColor
        self.view.layer.insertSublayer(pulseEffect, below: self.locationSymbolLabel.layer)
    }
    
    /// viewDidDisappear
    override func viewDidDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
        // invalidate the timer and release it.
        guard let timerUnwrapped = self.timer else{
            return
        }
        timerUnwrapped.invalidate()
        self.timer = nil
	}
	
    /// If Device is going landscape hide the location symbol and the pulse layer
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
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
	
    /// CLLocationManager Delegate if the User allowed oder denied the location request
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		switch status {
		case .AuthorizedWhenInUse:
            self.delegate?.locationRequestControllerDidChange(.LocationRequestAuthorized)
            self.dismissViewControllerAnimated(true) {
                self.delegate?.locationRequestControllerDidChange(.LocationRequestDidDisappear)
            }
			break
		case .AuthorizedAlways:
            self.delegate?.locationRequestControllerDidChange(.LocationRequestAuthorized)
            self.dismissViewControllerAnimated(true) {
                self.delegate?.locationRequestControllerDidChange(.LocationRequestDidDisappear)
            }
            break
		case .Denied:
            self.delegate?.locationRequestControllerDidChange(.LocationRequestDenied)
            self.dismissViewControllerAnimated(true) {
                self.delegate?.locationRequestControllerDidChange(.LocationRequestDidDisappear)
            }
			break
			
		default:
			break
		}
	}
	
    /// MKMapView Delegate regionDidChangeAnimated
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		if (self.rotatingCamera.isStopped() == true) {
			self.rotatingCamera.continueRotating()
		}
	}
	
    /// Add citys to cityCoordinate Array
    func fillCityOrLandmarks3DCoordinatesArray() {
		let parisEiffelTower = CLLocationCoordinate2DMake(48.85815,2.29452);
		let newYorkStatueOfLiberty = CLLocationCoordinate2DMake(40.689249, -74.044500);
		let sFGoldenGateBridge = CLLocationCoordinate2DMake(37.826040, -122.479448);
		let berlinBrandenburgerGate = CLLocationCoordinate2DMake(52.516275, 13.377704);
		let hamburgTownHall = CLLocationCoordinate2DMake(53.550416, 9.992527);
		let newYork = CLLocationCoordinate2DMake(40.702749, -74.014120);
		let cologneCathedral = CLLocationCoordinate2DMake(50.941278, 6.958281);
		let romeColosseum = CLLocationCoordinate2DMake(41.89021, 12.492231);
		let munichCurch = CLLocationCoordinate2DMake(48.138631, 11.573625);
		let neuschwansteinCastle = CLLocationCoordinate2DMake(47.557574, 10.749800);
		let londonBigBen = CLLocationCoordinate2DMake(51.500729, -0.124625);
		let londonEye = CLLocationCoordinate2DMake(51.503324, -0.119543);
		let sydneyOperaHouse = CLLocationCoordinate2DMake(-33.857197, 151.215140);
        let sagradaFamiliaSpain = CLLocationCoordinate2DMake(41.404024, 2.174370)
        let hamburgElbPhilharmonic = CLLocationCoordinate2DMake(53.541227, 9.984075)
        let griffithObservatory = CLLocationCoordinate2DMake(34.118536, -118.300446)
        let miamiBeach = CLLocationCoordinate2DMake(25.791007, -80.148082)
        let stonehenge = CLLocationCoordinate2DMake(51.178882, -1.826215)
		self.cityOrLandmarks3DCoordinates.append(parisEiffelTower)
		self.cityOrLandmarks3DCoordinates.append(newYorkStatueOfLiberty)
		self.cityOrLandmarks3DCoordinates.append(sFGoldenGateBridge)
		self.cityOrLandmarks3DCoordinates.append(berlinBrandenburgerGate)
		self.cityOrLandmarks3DCoordinates.append(hamburgTownHall)
		self.cityOrLandmarks3DCoordinates.append(newYork)
		self.cityOrLandmarks3DCoordinates.append(cologneCathedral)
		self.cityOrLandmarks3DCoordinates.append(romeColosseum)
		self.cityOrLandmarks3DCoordinates.append(munichCurch)
		self.cityOrLandmarks3DCoordinates.append(neuschwansteinCastle)
		self.cityOrLandmarks3DCoordinates.append(londonBigBen)
		self.cityOrLandmarks3DCoordinates.append(londonEye)
		self.cityOrLandmarks3DCoordinates.append(sydneyOperaHouse)
        self.cityOrLandmarks3DCoordinates.append(sagradaFamiliaSpain)
        self.cityOrLandmarks3DCoordinates.append(hamburgElbPhilharmonic)
        self.cityOrLandmarks3DCoordinates.append(griffithObservatory)
        self.cityOrLandmarks3DCoordinates.append(miamiBeach)
        self.cityOrLandmarks3DCoordinates.append(stonehenge)
	}

    /// Set a custom style for a given UIButton
    func setCustomButtonStyle(button: UIButton) {
		button.layer.borderWidth = 1.0
		button.layer.borderColor = UIColor.whiteColor().CGColor
		button.layer.cornerRadius = 5.0
		button.layer.masksToBounds = true
		button.setTitleColor(UIColor.clearColor().colorWithAlphaComponent(0.5), forState: UIControlState.Highlighted)
		button.setBackgroundImage(getImageWithColor(UIColor.whiteColor(), size: button.bounds.size), forState: UIControlState.Highlighted)
	}
	
    /// Return a UIImage with a given UIColor and CGSize
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
		let rect = CGRectMake(0, 0, size.width, size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	
    /// Get a random City and change the location on the map
	func changeRandomFlyOverCity() {
		let generateRandomNumber = randomSequenceGenerator(0, max: self.cityOrLandmarks3DCoordinates.count-1)
        let randomNumber = generateRandomNumber()
		UIView.animateWithDuration(0.5) { () -> Void in
			self.rotatingCamera.stopRotating()
			self.mapView.region = MKCoordinateRegionMakeWithDistance(self.cityOrLandmarks3DCoordinates[randomNumber], 1000, 1000)
			self.rotatingCamera.startRotatingWithCoordinate(self.cityOrLandmarks3DCoordinates[randomNumber], heading: 45, pitch: 45, altitude: 500, headingStep: 10)
		}
	}
    
    /// Get a random Index from an given array without repeating an index
    func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
        return {
            if self.randomNumbers.count == 0 {
                self.randomNumbers = Array(min...max)
            }
            let index = Int(arc4random_uniform(UInt32(self.randomNumbers.count)))
            return self.randomNumbers.removeAtIndex(index)
        }
    }
	
    /// Allow button was touched request authorization by AuthorizeType
	@IBAction func allowButtonTouched(sender: UIButton) {
        guard let authorizeTypeForLocationManager = self.authorizeType else{
            self.locationManager.requestWhenInUseAuthorization()
            return
        }
        if authorizeTypeForLocationManager == .RequestAlwaysAuthorization {
            self.locationManager.requestAlwaysAuthorization()
        }else{
            self.locationManager.requestWhenInUseAuthorization()
        }
	}
	
    /// Not now button was touched dismiss Viewcontroller
	@IBAction func notNowButtonTouched(sender: UIButton) {
        self.delegate?.locationRequestControllerDidChange(.NotNowButtonTapped)
        self.dismissViewControllerAnimated(true) { 
            self.delegate?.locationRequestControllerDidChange(.LocationRequestDidDisappear)
        }
	}
}
