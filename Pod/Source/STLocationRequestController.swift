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

/// STLocationRequestEvent Enum for events in the delegate Method locationRequestControllerDidChange
@objc public enum STLocationRequestControllerEvent : Int{
    case locationRequestAuthorized
    case locationRequestDenied
    case notNowButtonTapped
    case didPresented
    case didDisappear
}

/// STLocationRequestType Enum for decide which location request type should be used
@objc public enum STLocationRequestControllerAuthorizeType : Int{
    case requestWhenInUseAuthorization
    case requestAlwaysAuthorization
}

/// STLocationRequest Delegate
@objc public protocol STLocationRequestControllerDelegate{
    /**
     STLocationRequestControllerDelegate which is used to handle events from the STLocationRequestController.
     Example usage:
     ----
     func locationRequestControllerDidChange(event: STLocationRequestControllerEvent) {
     switch event {
        case .locationRequestAuthorized:
            break
        case .locationRequestDenied:
            break
        case .notNowButtonTapped:
            break
        case .didPresented:
            break
        case .didDisappear:
            break
        }
     }
     */
    @objc func locationRequestControllerDidChange(_ event : STLocationRequestControllerEvent)
}

/// STLocationRequest is a UIViewController-Extension which is used to request the User-Location, at the very first time, in a simple and elegent way. It shows a beautiful 3D 360 degree Flyover-MapView which shows 14 random citys or landmarks.
@objc open class STLocationRequestController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    /*
     Public properties of STLocationRequestController
    */
    
    /// The title which will be presented at the top of the STLocationRequestController. Default-Value: "We need your location for some awesome features"
    open var titleText = "We need your location for some awesome features"

    /// The title which will be presented at the top of the STLocationRequestController. Default-Value: UIFont.systemFontOfSize(25.0)
    open var titleFont = UIFont.systemFont(ofSize: 25.0)
    
    /// The title for the allowButton which will trigger the requestWhenInUseAuthorization() Method on CLLocationManager. Default value is "Alright"
    open var allowButtonTitle = "Alright"
    
    /// The title for the notNowButton which will dismiss the STLocationRequestController. Default value is "Not now"
    open var notNowButtonTitle = "Not now"
    
    /// The alpha value for the MapView which is used in combination with `backgroundViewColor` to match the STLocationRequestController with the design of your app. Default value is 1
    open var mapViewAlpha : CGFloat = 1.0
    
    /// The backgroundcolor for the view of the STLocationRequestController which is used in combination with `mapViewAlphaValue` to match the STLocationRequestController with the design of your app. Default value is a white color.
    open var backgroundColor = UIColor.white
    
    /// Defines if the pulse Effect which will displayed under the location symbol should be enabled or disabled. Default Value: true
    open var pulseEffectEnabled = true
    
    /// The color for the pulse effect behind the location symbol. Default value: white
    open var pulseEffectColor = UIColor.white
    
    /// Set the location symbol icon which will be displayed in the middle of the location request screen. Default value: FAType.FALocationArrow. Which icons are available can be found on http://fontawesome.io/icons/ or https://github.com/Vaberer/Font-Awesome-Swift.
    open var locationSymbolIcon = FAType.FALocationArrow
    
    /// The color of the location symbol which will be presented in the middle of the location request screen. Default value: white
    open var locationSymbolColor = UIColor.white
    
    /// Defines if the location symbol which will be presented in the middle of the location request screen is hidden. Default value: false
    open var locationSymbolHidden = false
    
    /// Set the authorize Type for STLocationRequestController. Choose between: `RequestWhenInUseAuthorization` and `RequestAlwaysAuthorization`. Default value is `RequestWhenInUseAuthorization`
    open var authorizeType = STLocationRequestControllerAuthorizeType.requestWhenInUseAuthorization
    
    /// STLocationRequestDelegate which is used to handle events from the STLocationRequestController.
    open var delegate : STLocationRequestControllerDelegate?
    
    /// Set the in the interval for switching the shown places in seconds. Default value is 15 seconds
    open var timeTillPlaceSwitchesInSeconds = 15.0
    
    /*
        Public Functions
    */
    
    /**
     Return an instance of STLocationRequestController loaded up from the embedded Storyboard within the Pod
     
     Example usage:
     ----
     let locationRequest = STLocationRequestController.getInstance()
     locationRequest.titleText = "We need your location for some awesome features"
     locationRequest.titleFont = UIFont.systemFontOfSize(25.0)
     locationRequest.allowButtonTitle = "Alright"
     locationRequest.notNowButtonTitle = "Not now"
     locationRequest.mapViewAlphaValue = 0.9
     locationRequest.backgroundViewColor = UIColor.lightGrayColor()
     locationRequest.delegate = self
     locationRequest.authorizeType = .RequestWhenInUseAuthorization
     locationRequest.presentLocationRequestController(onViewController: self)
     
     More Information
     --------------
     
     More information can be found in the ReadMe file [Github](https://github.com/SvenTiigi/STLocationRequest/blob/master/README.md)
     
    */
    open static func getInstance() -> STLocationRequestController{
        // Create the Bundle Path for Resources
        let bundlePath = Bundle(for: STLocationRequestController.self).path(forResource: "STLocationRequest", ofType: "bundle")
        
        // Get the Storyboard File
        let stb = UIStoryboard(name: "StoryboardLocationRequest", bundle:Bundle(path: bundlePath!))
        
        // Instantiate the ViewController by Identifer as STLocationRequestController
        let locationRequestController = stb.instantiateViewController(withIdentifier: "locationRequestController") as! STLocationRequestController
        
        // Set the loadedFromStoryboard attribute to true
        locationRequestController.loadedFromStoryboard = true
        
        // Return the STLocationRequestController instance
        return locationRequestController
    }
    
    /**
     Present the STLocationRequestController modally on a given UIViewController
     
     iOS Simulator:
     ----
     Please mind that the 3D Flyover-View will only work on a **real** iOS Device **not** in the Simulator with at least iOS 9.0 installed
     
     - parameters:
     - viewController: The `UIViewController` which will be used to present the STLocationRequestController modally.
     */
    open func present(onViewController viewController : UIViewController){
        if loadedFromStoryboard {
            viewController.present(self, animated: true) {
                self.delegate?.locationRequestControllerDidChange(.didPresented)
            }
        }else{
            print("WARNING: Please initialize the STLocationRequestController via \"STLocationRequestController.getInstance()\" otherwise the Storyboard File can't be loaded from the Pod")
        }
    }
    
    /*
     Private properties of STLocationRequestController
    */
    
    /// IBOutlet connection allow location services button
	@IBOutlet weak var allowButton: UIButton!
    
    /// IBOutlet connection not now button
	@IBOutlet weak var notNowButton: UIButton!
    
    /// IBOutlet connection MKMapView
	@IBOutlet weak var mapView: MKMapView!
    
    /// IBOutlet connection description label
	@IBOutlet weak var descriptionLabel: UILabel!
    
    /// IBOutlet connection location symbol
	@IBOutlet weak var locationSymbolLabel: UILabel!
    
	/// CitryCoordinate array
	fileprivate var places = STAwesomePlacesFactory.getAwesomePlaces()
	
	/// Array to store random integer values
    fileprivate var randomNumbers: [Int] = []
	
	/// Initialize STRotatingCamera
	fileprivate var rotatingCamera = STRotatingCamera()
	
	/// CLLocationManager
	fileprivate var locationManager = CLLocationManager()
    
    /// PulseEffect
	fileprivate var pulseEffect = LFTPulseAnimation(radius: 0, position: CGPoint(x: 0,y: 0))
    
    /// Variable for NSTimer
    fileprivate var timer : Timer?
    
    /// Variable to check if getInstance was called
    fileprivate var loadedFromStoryboard = false
    
    /// viewDidLoad Function
    override open func viewDidLoad() {
		super.viewDidLoad()
        // Set the text for the description label
        self.descriptionLabel.text = self.titleText
        // Set the font for the description label
        self.descriptionLabel.font = self.titleFont
        // Set the title for the allow button
        self.allowButton.setTitle(allowButtonTitle, for: UIControlState())
        // Set the title for the not now button
        self.notNowButton.setTitle(notNowButtonTitle, for: UIControlState())
        // Setting the alpha value for MKMapView
        self.mapView.alpha = self.mapViewAlpha
        // Setting the backgroundColor for the UIView of STLocationRequestController
        self.view.backgroundColor = self.backgroundColor
        // Set the settings for MKMapView and check if SatelliteFlyover is available
        if #available(iOS 9.0, *) {
            self.mapView.mapType = .satelliteFlyover
            self.mapView.showsCompass = false
            self.mapView.showsScale = false
        } else {
            self.mapView.mapType = .satellite
        }
		// Set the Delegate of the locationManager
		self.locationManager.delegate = self
		// Set the location-symbol using fontAwesom
        if !locationSymbolHidden {
            self.locationSymbolLabel.setFAIcon(icon: locationSymbolIcon, iconSize: 150)
            self.locationSymbolLabel.textColor = locationSymbolColor
        }else{
            self.locationSymbolLabel.text = ""
        }
		// Set custom stlye to the UIButton (allowButton and notNowButton)
		self.setCustomButtonStyle(self.allowButton)
		self.setCustomButtonStyle(self.notNowButton)
        // Add the Pulse-Effect under the Location-Symbol
        if pulseEffectEnabled {
            self.addPulseEffect()
        }
		// Create a rotating camera object and pass a mapView
		self.rotatingCamera = STRotatingCamera(mapView: self.mapView)
		// Start the flyover Magic
		self.changeRandomFlyOverCity()
		// Start the timer for changing location even more magic here :)
		self.timer = Timer.scheduledTimer(timeInterval: self.timeTillPlaceSwitchesInSeconds, target: self, selector: #selector(STLocationRequestController.changeRandomFlyOverCity), userInfo: nil, repeats: true)
	}
    
    /// Adding the pulse effect under the Location-Symbol in the middle of the STLocationRequest Screen
    fileprivate func addPulseEffect(){
        // Setting the Pulse Effect
        self.pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:180, position:self.view.center)
        self.pulseEffect.backgroundColor = self.pulseEffectColor.cgColor
        self.view.layer.insertSublayer(pulseEffect, below: self.locationSymbolLabel.layer)
    }
    
    /// viewDidDisappear
    override open func viewDidDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        // invalidate the timer and release it.
        guard let timerUnwrapped = self.timer else{
            return
        }
        timerUnwrapped.invalidate()
        self.timer = nil
	}
	
    /// If Device is going landscape hide the location symbol and the pulse layer
	override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		if UIDevice.current.orientation.isLandscape {
			UIView.animate(withDuration: 0.5, animations: { () -> Void in
				self.locationSymbolLabel.alpha = 1
				self.locationSymbolLabel.alpha = 0
			})
			
			self.pulseEffect.setPulseRadius(0)
		} else {
			UIView.animate(withDuration: 0.5, animations: { () -> Void in
				self.locationSymbolLabel.alpha = 0
				self.locationSymbolLabel.alpha = 1
			})
			
			self.pulseEffect.setPulseRadius(180)
		}
	}
    
    /// CLLocationManager Delegate if the User allowed oder denied the location request
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedWhenInUse:
            self.fireEventAndDismissViewController(.locationRequestAuthorized)
			break
		case .authorizedAlways:
            self.fireEventAndDismissViewController(.locationRequestAuthorized)
            break
		case .denied:
            self.fireEventAndDismissViewController(.locationRequestDenied)
			break
		default:
			break
		}
	}
    
    /// Fire STLocationRequestEvent and Dismiss ViewController
    func fireEventAndDismissViewController(_ event : STLocationRequestControllerEvent){
        self.delegate?.locationRequestControllerDidChange(event)
        self.dismiss(animated: true) {
            self.delegate?.locationRequestControllerDidChange(.didDisappear)
        }
    }
	
    /// MKMapView Delegate regionDidChangeAnimated
    open func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		if (self.rotatingCamera.isStopped() == true) {
			self.rotatingCamera.continueRotating()
		}
	}

    /// Set a custom style for a given UIButton
    func setCustomButtonStyle(_ button: UIButton) {
		button.layer.borderWidth = 1.0
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.cornerRadius = 5.0
		button.layer.masksToBounds = true
		button.setTitleColor(UIColor.clear.withAlphaComponent(0.5), for: UIControlState.highlighted)
		button.setBackgroundImage(getImageWithColor(UIColor.white, size: button.bounds.size), for: UIControlState.highlighted)
	}
	
    /// Return a UIImage with a given UIColor and CGSize
    func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
	
    /// Get a random City and change the location on the map
	func changeRandomFlyOverCity() {
		let generateRandomNumber = randomSequenceGenerator(0, max: self.places.count-1)
        let randomNumber = generateRandomNumber()
		UIView.animate(withDuration: 0.5, animations: { () -> Void in
			self.rotatingCamera.stopRotating()
			self.mapView.region = MKCoordinateRegionMakeWithDistance(self.places[randomNumber], 1000, 1000)
			self.rotatingCamera.startRotatingWithCoordinate(self.places[randomNumber], heading: 45, pitch: 45, altitude: 500, headingStep: 10)
		}) 
	}
    
    /// Get a random Index from an given array without repeating an index
    func randomSequenceGenerator(_ min: Int, max: Int) -> () -> Int {
        return {
            if self.randomNumbers.count == 0 {
                self.randomNumbers = Array(min...max)
            }
            let index = Int(arc4random_uniform(UInt32(self.randomNumbers.count)))
            return self.randomNumbers.remove(at: index)
        }
    }
	
    /// Allow button was touched request authorization by AuthorizeType
	@IBAction func allowButtonTouched(_ sender: UIButton) {
        if self.authorizeType == .requestAlwaysAuthorization {
            self.locationManager.requestAlwaysAuthorization()
        }else{
            self.locationManager.requestWhenInUseAuthorization()
        }
	}
	
    /// Not now button was touched dismiss Viewcontroller
	@IBAction func notNowButtonTouched(_ sender: UIButton) {
        self.fireEventAndDismissViewController(.notNowButtonTapped)
	}
    
}
