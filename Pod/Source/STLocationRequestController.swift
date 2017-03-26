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

// MARK: - STLocationRequestControllerEvent

/// STLocationRequestEvent Enum for events in the delegate Method locationRequestControllerDidChange
@objc public enum STLocationRequestControllerEvent: Int {
    /// The user authorized the location request
    case locationRequestAuthorized
    /// The user denied the location request
    case locationRequestDenied
    /// The user tapped the "Not now"-Button
    case notNowButtonTapped
    /// The STLocationRequestController did presented
    case didPresented
    /// The STLocationRequestController did disappear
    case didDisappear
}

// MARK: - STLocationRequestControllerAuthorizeType

/// STLocationRequestType Enum for decide which location request type should be used
@objc public enum STLocationRequestControllerAuthorizeType: Int {
    /// Location-Request when in use authorization
    case requestWhenInUseAuthorization
    /// Location-Request always authorization
    case requestAlwaysAuthorization
}

// MARK: - STLocationRequestControllerDelegate

/// STLocationRequest Delegate
@objc public protocol STLocationRequestControllerDelegate {
    /**
     STLocationRequestControllerDelegate which is used to handle events from the STLocationRequestController.
     - Parameter event: Enum which contains the event of STLocationRequestControllerEvent
     Example usage:
     ----
     ````
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
     ````
     */
    @objc func locationRequestControllerDidChange(_ event: STLocationRequestControllerEvent)
}

// MARK: - STLocationRequestController

/// STLocationRequest is a UIViewController-Extension which is used to request the User-Location, at the very first time, in a simple and elegent way. It shows a beautiful 3D 360 degree Flyover-MapView which shows 14 random citys or landmarks.
@objc public class STLocationRequestController: UIViewController {

    // MARK: - (API) Public properties
    
    /// The title which will be presented at the top of the STLocationRequestController. Default-Value: "We need your location for some awesome features"
    public var titleText: String = "We need your location for some awesome features"

    /// The title which will be presented at the top of the STLocationRequestController. Default-Value: UIFont.systemFontOfSize(25.0)
    public var titleFont: UIFont = .systemFont(ofSize: 25.0)
    
    /// The title for the allowButton which will trigger the requestWhenInUseAuthorization() or requestAlwaysAuthorization() Method on CLLocationManager. Default value is "Alright"
    public var allowButtonTitle: String = "Alright"
    
    /// The title for the notNowButton which will dismiss the STLocationRequestController. Default value is "Not now"
    public var notNowButtonTitle: String = "Not now"
    
    /// The alpha value for the MapView which is used in combination with `backgroundViewColor` to match the STLocationRequestController with the design of your app. Default value is 1
    public var mapViewAlpha: CGFloat = 1.0
    
    /// The backgroundcolor for the view of the STLocationRequestController which is used in combination with `mapViewAlphaValue` to match the STLocationRequestController with the design of your app. Default value is a white color.
    public var backgroundColor: UIColor = .white
    
    /// Defines if the pulse Effect which will displayed under the location symbol should be enabled or disabled. Default Value: true
    public var isPulseEffectEnabled: Bool = true
    
    /// The color for the pulse effect behind the location symbol. Default value: white
    public var pulseEffectColor: UIColor = .white
    
    /// Set the location symbol icon which will be displayed in the middle of the location request screen. Default value: FAType.FALocationArrow. Which icons are available can be found on http://fontawesome.io/icons/ or https://github.com/Vaberer/Font-Awesome-Swift.
    public var locationSymbolIcon: FAType = .FALocationArrow
    
    /// The color of the location symbol which will be presented in the middle of the location request screen. Default value: white
    public var locationSymbolColor: UIColor = .white
    
    /// Defines if the location symbol which will be presented in the middle of the location request screen is hidden. Default value: false
    public var isLocationSymbolHidden: Bool = false
    
    /// Set the authorize Type for STLocationRequestController. Choose between: `.requestWhenInUseAuthorization` and `.requestAlwaysAuthorization`. Default value is `.requestWhenInUseAuthorization`
    public var authorizeType: STLocationRequestControllerAuthorizeType = .requestWhenInUseAuthorization
    
    /// STLocationRequestDelegate which is used to handle events from the STLocationRequestController.
    public var delegate: STLocationRequestControllerDelegate?
    
    /// Set the in the interval for switching the shown places in seconds. Default value is 15 seconds
    public var timeTillPlaceSwitchesInSeconds: TimeInterval = 15.0
    
    /// Fill the optional value `placesFilter` if you wish to specify which places should be shown. Default value is "nil" which means all places will be shown
    public var placesFilter: [STAwesomePlace]?
    
    // MARK: - Public functions
    
    /**
     Return an instance of STLocationRequestController loaded up from the embedded Storyboard within the Pod
     
     Example usage:
     ----
     ````
     let locationRequest = STLocationRequestController.getInstance()
     locationRequest.titleText = "We need your location for some awesome features"
     locationRequest.allowButtonTitle = "Alright"
     locationRequest.notNowButtonTitle = "Not now"
     locationRequest.delegate = self
     locationRequest.authorizeType = .requestWhenInUseAuthorization
     locationRequest.presentLocationRequestController(onViewController: self)
     ````
     More Information
     ----
     
     More information can be found in the ReadMe file on [Github](https://github.com/SvenTiigi/STLocationRequest/blob/master/README.md)
     
    */
    public static func getInstance() -> STLocationRequestController {
        // Create the Bundle Path for Resources
        guard let bundlePath = Bundle(for: STLocationRequestController.self).path(forResource: "STLocationRequest", ofType: "bundle") else {
            print("STLocationRequestController_ERROR☝️: The bundle path which is used to identifiy the custom Storyboard cant't be loaded")
            return STLocationRequestController()
        }
        // Get the Storyboard File
        let stb = UIStoryboard(name: "StoryboardLocationRequest", bundle:Bundle(path: bundlePath))
        // Instantiate the ViewController by Identifer as STLocationRequestController
        guard let locationRequestController = stb.instantiateViewController(withIdentifier: "locationRequestController") as? STLocationRequestController else {
            print("STLocationRequestController_ERROR☝️: The ViewController can't be casted to STLocationRequestController")
            return STLocationRequestController()
        }
        // Set the loadedFromStoryboard attribute to true
        locationRequestController.isLoadedFromInstance = true
        // Return the STLocationRequestController instance
        return locationRequestController
    }
    
    /**
     Present the STLocationRequestController modally on a given UIViewController
     
     iOS Simulator:
     ----
     Please mind that the 3D Flyover-View will only work on a **real** iOS Device **not** in the Simulator with at least iOS 9.0 installed
     
     - Parameter viewController: The `UIViewController` which will be used to present the STLocationRequestController modally.
     */
    public func present(onViewController viewController: UIViewController, completion: (() -> Void)? = nil) {
        // Check if STLocationRequestController was loaded via "STLocationRequestController.getInstance()"
        if self.isLoadedFromInstance {
            // Check if app is running on iOS Simulator
            #if (arch(i386) || arch(x86_64)) && os(iOS)
                print("STLocationRequestController_WARNING☝️: Please keep in mind that the 3D-SatelliteFlyover only works on a real iOS Device and not on the iOS Simulator. Read more here -> https://github.com/SvenTiigi/STLocationRequest#ios-simulator")
            #endif
            // The STLocationRequestController is correctly initialized. Present the STLocationRequestController
            viewController.present(self, animated: true) {
                // After presenting the STLocationRequestController inform the delegate
                self.delegate?.locationRequestControllerDidChange(.didPresented)
                guard let completion = completion else {
                    return
                }
                completion()
            }
        }else{
            // The STLocationRequestController was not correctly initialized. Inform the developer via terminal output
            print("STLocationRequestController_WARNING☝️: Please initialize the STLocationRequestController via \"STLocationRequestController.getInstance()\" otherwise the Storyboard-File can't be loaded from the Pod")
        }
    }
    
    /**
     Add your custom location via CLLocationCoordinate2D to the STLocationRequestController.
     If you wish that STLocationRequestController should show only your customPlaces,
     set the placesFilter to .customPlaces
     
     SatelliteFlyover:
     ----
     Please keep in mind to check if your location is available in 3D-Flyover mode.
     To check just go to Apple Maps App and search your location and tap on the 3D-Button
     */
    public func addPlace(coordinate place: CLLocationCoordinate2D) {
        // Check if customPlaces is already initialized
        guard var customPlaces = self.customPlaces else {
            // customPlaces is nil. Initialize it
            self.customPlaces = [CLLocationCoordinate2D]()
            // Append the place
            self.customPlaces?.append(place)
            return
        }
        // customPlaces is already initialized append it
        customPlaces.append(place)
    }
    
    /**
     Add your custom location via latitude and longitude to the STLocationRequestController.
     If you wish that STLocationRequestController should show only your customPlaces,
     set the placesFilter to .customPlaces
     
     SatelliteFlyover:
     ----
     Please keep in mind to check if your location is available in 3D-Flyover mode.
     To check just go to Apple Maps App and search your location and tap on the 3D-Button
     */
    public func addPlace(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.addPlace(coordinate: coordinate)
    }
    
    
    // MARK: - IBOutlets
    
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
    
    // MARK: - Private properties
    
	/// CitryCoordinate array
    fileprivate var places: [CLLocationCoordinate2D] = []
	
	/// Array to store random integer values
    fileprivate var randomNumbers: [Int] = []
	
	/// Initialize STRotatingCamera
	fileprivate var rotatingCamera = STRotatingCamera()
	
	/// CLLocationManager
	fileprivate var locationManager = CLLocationManager()
    
    /// PulseEffect
	fileprivate var pulseEffect = LFTPulseAnimation(radius: 0, position: CGPoint(x: 0,y: 0))
    
    /// PulseEffect Radius
    fileprivate var pulseRadius: CGFloat = 180.0
    
    /// Variable for Timer that is changing the current place
    fileprivate var placeChangeTimer: Timer?
    
    /// Variable to check if getInstance was called
    fileprivate var isLoadedFromInstance = false
    
    /// CustomPlaces Array, which can be append via addPlace() function
    fileprivate var customPlaces: [CLLocationCoordinate2D]?
    
    // MARK: - ViewDidLoad main initializing
    
    /// viewDidLoad Function
    override public func viewDidLoad() {
		super.viewDidLoad()
        // Set the text for the description label
        self.descriptionLabel.text = self.titleText
        // Set the font for the description label
        self.descriptionLabel.font = self.titleFont
        // Set the title for the allow button
        self.allowButton.setTitle(self.allowButtonTitle, for: UIControlState())
        // Set the title for the not now button
        self.notNowButton.setTitle(self.notNowButtonTitle, for: UIControlState())
        // Setting the alpha value for MKMapView
        self.mapView.alpha = self.mapViewAlpha
        // Setting the backgroundColor for the UIView of STLocationRequestController
        self.view.backgroundColor = self.backgroundColor
        // Set the settings for MKMapView and check if SatelliteFlyover is available
        if #available(iOS 9.0, *) {
            // Activate satelliteFlyover and disable compass and scale
            self.mapView.mapType = .satelliteFlyover
            self.mapView.showsCompass = false
            self.mapView.showsScale = false
        } else {
            // Fallback properties for < iOS 9.0
            self.mapView.mapType = .satellite
        }
        // Load all awesome places with a places filter
        self.places = STAwesomePlacesFactory.getAwesomePlaces(withPlacesFilter: self.placesFilter, andCustomPlaces: self.customPlaces)
		// Set the Delegate of the locationManager
		self.locationManager.delegate = self
		// Set the location symbol properties
        self.locationSymbolLabel.isHidden = self.isLocationSymbolHidden
        // The location symbol is not hidden. Set the fontAwesome icon
        self.locationSymbolLabel.setFAIcon(icon: self.locationSymbolIcon, iconSize: 150)
        // Set the textColor for fontAwesome icon
        self.locationSymbolLabel.textColor = self.locationSymbolColor
		// Set custom stlye to the UIButton (allowButton and notNowButton)
        self.setCustomButtonStyle(forButtons: [self.allowButton, self.notNowButton])
        // Add the Pulse-Effect under the Location-Symbol
        if self.isPulseEffectEnabled {
            self.addPulseEffect()
        }
		// Create a rotating camera object and pass a mapView
		self.rotatingCamera = STRotatingCamera(mapView: self.mapView)
		// Start showing awesome places
		self.changeAwesomePlace(timer: nil)
		// Start the timer for changing location even more magic here :)
		self.placeChangeTimer = Timer.scheduledTimer(timeInterval: self.timeTillPlaceSwitchesInSeconds, target: self, selector: #selector(STLocationRequestController.changeAwesomePlace(timer:)), userInfo: nil, repeats: true)
	}
    
    // MARK: - LFTPulseAnimation
    
    /// Adding the pulse effect under the Location-Symbol in the middle of the STLocationRequest Screen
    fileprivate func addPulseEffect() {
        // Setting the Pulse Effect
        self.pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:self.pulseRadius, position:self.view.center)
        self.pulseEffect.backgroundColor = self.pulseEffectColor.cgColor
        self.view.layer.insertSublayer(self.pulseEffect, below: self.locationSymbolLabel.layer)
    }
    
    // MARK: - PlaceChangeTimer invalidation
    
    /// viewDidDisappear
    override public func viewDidDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        self.destroyPlaceChangeTimer()
	}
    
    /// deinit
    deinit {
        self.destroyPlaceChangeTimer()
    }
    
    /// Destroy the placeChangeTimer
    fileprivate func destroyPlaceChangeTimer() {
        guard let timerUnwrapped = self.placeChangeTimer else{
            return
        }
        timerUnwrapped.invalidate()
        self.placeChangeTimer = nil
    }
    
    // MARK: - Orientation changed
	
    /// If Device is going landscape hide the location symbol and the pulse layer
	override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		if UIDevice.current.orientation.isLandscape {
            // The device orientation is landscape. Hide the locationSymbolLabel
			UIView.animate(withDuration: 0.5, animations: { () -> Void in
				self.locationSymbolLabel.alpha = 1
				self.locationSymbolLabel.alpha = 0
			})
			self.pulseEffect.setPulseRadius(0)
		} else {
            // The device orientation is portrait. Show the locationSymbolLabel
			UIView.animate(withDuration: 0.5, animations: { () -> Void in
				self.locationSymbolLabel.alpha = 0
				self.locationSymbolLabel.alpha = 1
			})
			self.pulseEffect.setPulseRadius(self.pulseRadius)
		}
	}
    
    // MARK: - Helper functions
    
    /// Fire STLocationRequestEvent and dismiss ViewController
    ///
    /// - Parameter event: The event which should be trigged before dismissing the STLocationRequestController
    fileprivate func fireEventAndDismissViewController(forEvent event: STLocationRequestControllerEvent) {
        // Inform the delegate which event got triggered
        self.delegate?.locationRequestControllerDidChange(event)
        // Dismiss the STLocationRequestController
        self.dismiss(animated: true) {
            // Inform the delegate, that the STLocationRequestController is disappeared
            self.delegate?.locationRequestControllerDidChange(.didDisappear)
        }
    }

    // MARK: - UIButton custom styling
    
    /// Set a custom style for a given UIButton
    ///
    /// - Parameter button: UIButton which should be styled
    fileprivate func setCustomButtonStyle(forButtons buttons: [UIButton]) {
        for button in buttons {
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 5.0
            button.layer.masksToBounds = true
            button.setTitleColor(UIColor.clear.withAlphaComponent(0.5), for: UIControlState.highlighted)
            button.setBackgroundImage(self.getImageWithColor(UIColor.white, size: button.bounds.size), for: UIControlState.highlighted)
        }
	}

    /// Return a UIImage with a given UIColor and CGSize
    ///
    /// - Parameters:
    ///   - color: The color of the returned UIImage
    ///   - size: The size of the returned UIImage
    /// - Returns: Optional UIImage
    fileprivate func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(rect)
		let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
    
    // MARK: - Change AwesomePlaces
    
    /// Change the current awesome place
    @objc fileprivate func changeAwesomePlace(timer: Timer?) {
        // If the timer is not nil and there is only one place return the function
        if timer != nil && self.places.count == 1 {
            return
        }
		let awesomePlace = self.getRandomAwesomePlace()
		UIView.animate(withDuration: 0.5, animations: { () -> Void in
			self.rotatingCamera.stopRotating()
			self.mapView.region = MKCoordinateRegionMakeWithDistance(awesomePlace, 1000, 1000)
			self.rotatingCamera.startRotatingWithCoordinate(awesomePlace, heading: 45, pitch: 45, altitude: 500, headingStep: 10)
		}) 
	}

    /// Retrieve a random awesome place coordinate
    ///
    /// - Returns: CLLocationCoordinate2D
    fileprivate func getRandomAwesomePlace() -> CLLocationCoordinate2D {
        let generateRandomNumber = self.randomSequenceGenerator(0, max: self.places.count-1)
        return self.places[generateRandomNumber()]
    }

    /// Get a random Index from an given array without repeating an index
    ///
    /// - Parameters:
    ///   - min: min. value
    ///   - max: max. value
    /// - Returns: random integer (without a repeating random int)
    fileprivate func randomSequenceGenerator(_ min: Int, max: Int) -> () -> Int {
        return {
            if self.randomNumbers.count == 0 {
                self.randomNumbers = Array(min...max)
            }
            let index = Int(arc4random_uniform(UInt32(self.randomNumbers.count)))
            return self.randomNumbers.remove(at: index)
        }
    }
    
    // MARK: - IBActions Allow & NotNow UIButtons
	
	/// Allow button was touched request authorization by AuthorizeType
	///
	/// - Parameter sender: UIButton
	@IBAction func allowButtonTouched(_ sender: UIButton) {
        switch self.authorizeType {
        case .requestAlwaysAuthorization:
            self.locationManager.requestAlwaysAuthorization()
            break
        case .requestWhenInUseAuthorization:
            self.locationManager.requestWhenInUseAuthorization()
            break
        }
	}

	/// Not now button was touched dismiss Viewcontroller
	///
	/// - Parameter sender: UIButton
	@IBAction func notNowButtonTouched(_ sender: UIButton) {
        self.fireEventAndDismissViewController(forEvent: .notNowButtonTapped)
	}
    
}

// MARK: - CLLocationManagerDelegate

extension STLocationRequestController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check the authorization state from CLLocationManager
        switch status {
        case .authorizedWhenInUse:
            self.fireEventAndDismissViewController(forEvent: .locationRequestAuthorized)
            break
        case .authorizedAlways:
            self.fireEventAndDismissViewController(forEvent: .locationRequestAuthorized)
            break
        case .denied:
            self.fireEventAndDismissViewController(forEvent: .locationRequestDenied)
            break
        case .restricted:
            self.fireEventAndDismissViewController(forEvent: .locationRequestDenied)
            break;
        case .notDetermined:
            break;
        }
    }
    
}

// MARK: - MKMapViewDelegate

extension STLocationRequestController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // If the rotating camera did stopped while region changed, continue rotating
        if (self.rotatingCamera.isStopped() == true) {
            self.rotatingCamera.continueRotating()
        }
    }
    
}
