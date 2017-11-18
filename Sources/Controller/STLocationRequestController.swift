//
//  STLocationRequestController.swift
//  Pods
//
//  Created by Sven Tiigi on 02.12.15.
//
//

import UIKit
import CoreLocation
import MapKit
import Font_Awesome_Swift

/**
    STLocationRequest is a UIViewController-Extension which is used to request the User-Location, at the very first time, in a simple and elegent way.
    It shows a beautiful 3D 360 degree Flyover-MapView which shows 14 random citys or landmarks.
 */
@objcMembers public class STLocationRequestController: UIViewController {

    // MARK: Public properties
    
    /// The title which will be presented at the top of the STLocationRequestController. Default-Value: "We need your location for some awesome features"
    public var titleText: String = "We need your location for some awesome features"

    /// The title which will be presented at the top of the STLocationRequestController. Default-Value: UIFont.systemFontOfSize(25.0)
    public var titleFont: UIFont = .systemFont(ofSize: 25.0)
    
    /// The title for the allowButton which will trigger the requestWhenInUseAuthorization() or requestAlwaysAuthorization() Method on CLLocationManager. Default value is "Alright"
    public var allowButtonTitle: String = "Alright"
    
    /// The allowButton font. Default value is `systemFont(ofSize: 21)`
    public var allowButtonFont: UIFont = .systemFont(ofSize: 21)
    
    /// The title for the notNowButton which will dismiss the STLocationRequestController. Default value is "Not now"
    public var notNowButtonTitle: String = "Not now"
    
    /// The notNowButton font. Default value is `systemFont(ofSize: 21)`
    public var notNowButtonFont: UIFont = .systemFont(ofSize: 21)
    
    /// The alpha value for the MapView which is used in combination with `backgroundViewColor` to match the STLocationRequestController with the design of your app. Default value is 1
    public var mapViewAlpha: CGFloat = 1.0
    
    /// The MapView camera altitude. Default value is `600`
    public var mapViewCameraAltitude: CLLocationDistance = 600
    
    /// The MapView camera pitch. Default value is `45`
    public var mapViewCameraPitch: CGFloat = 45
    
    /// The MapView camera heading step. Default value is `20`
    public var mapViewCameraHeadingStep: Double = 20
    
    /// The MapView camera animation duration. Default value is `4`
    public var mapViewCameraRotationAnimationDuration: Double = 4
    
    /// The backgroundcolor for the view of the STLocationRequestController which is used in combination with `mapViewAlphaValue` to match the STLocationRequestController with the design of your app. Default value is a white color.
    public var backgroundColor: UIColor = .white
    
    /// Defines if the pulse Effect which will displayed under the location symbol should be enabled or disabled. Default Value: true
    public var isPulseEffectEnabled: Bool = true
    
    /// The color for the pulse effect behind the location symbol. Default value: white
    public var pulseEffectColor: UIColor = .white
    
    /// The pulse effect radius. Default value is `180`
    public var pulseEffectRadius: CGFloat = 180.0
    
    /// Set the location symbol icon which will be displayed in the middle of the location request screen. Default value: FAType.FALocationArrow. Which icons are available can be found on http://fontawesome.io/icons/ or https://github.com/Vaberer/Font-Awesome-Swift.
    public var locationSymbolIcon: FAType = .FALocationArrow
    
    /// The location symbol size. Default value is `150`
    public var locationSymbolSize: CGFloat = 150
    
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
    public var placesFilter: [STLocationRequestPlace]?
    
    /// The onChange closure
    public var onChange: ((STLocationRequestControllerEvent) -> Void)?
    
    /// The preferredStatusBarStyle light value
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Private properties
    
    /// The Allow-Button
    lazy private var allowButton: UIButton = {
        let button = STLocationRequestButton(
            title: self.allowButtonTitle,
            font: self.allowButtonFont,
            target: self,
            action: #selector(allowButtonTouched)
        )
        return button
    }()
    
    /// The Not-Now-Button
    lazy private var notNowButton: UIButton = {
        let button = STLocationRequestButton(
            title: self.notNowButtonTitle,
            font: self.notNowButtonFont,
            target: self,
            action: #selector(notNowButtonTouched)
        )
        return button
    }()
    
    /// The MapView
    lazy private var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .satelliteFlyover
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.alpha = self.mapViewAlpha
        return mapView
    }()
    
    /// TitleLabel
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.titleText
        label.textAlignment = .center
        label.font = self.titleFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        // TODO: DisbaledControltext as shadowColor
        label.shadowColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
        label.shadowOffset = CGSize(width: 0, height: 1)
        return label
    }()
    
    /// Location Symbol Label
    lazy private var locationSymbolLabel: UILabel = {
        let label = UILabel()
        label.isHidden = self.isLocationSymbolHidden
        label.setFAIcon(icon: self.locationSymbolIcon, iconSize: self.locationSymbolSize)
        label.textColor = self.locationSymbolColor
        label.textAlignment = .center
        return label
    }()
    
    /// The pulse effect
    lazy private var pulseEffect: LFTPulseAnimation = {
        let pulseEffect = LFTPulseAnimation(repeatCount: Float.infinity, radius:self.pulseEffectRadius, position:self.view.center)
        pulseEffect.backgroundColor = self.pulseEffectColor.cgColor
        pulseEffect.isHidden = !self.isPulseEffectEnabled
        return pulseEffect
    }()
    
	/// Places Coordinate array
    lazy private var places: [CLLocationCoordinate2D] = {
        return STLocationRequestPlaceFactory.getPlaces(
            withPlacesFilter: self.placesFilter,
            andCustomPlaces: self.customPlaces
        )
    }()
    
    /// CustomPlaces Array, which can be append via addPlace() function
    lazy private var customPlaces: [CLLocationCoordinate2D] = {
        let places: [CLLocationCoordinate2D] = []
        return places
    }()
	
	/// Array to store random integer values
    lazy private var randomNumbers: [Int] = {
        let numbers: [Int] = []
        return numbers
    }()
	
	/// CLLocationManager
    lazy private var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    /// The MapCamera
    lazy private var mapCamera: MKMapCamera = {
       let camera = MKMapCamera()
        camera.altitude = self.mapViewCameraAltitude
        camera.pitch = self.mapViewCameraPitch
        camera.heading = 0
        return camera
    }()
    
    /// The place change timer
    private var placeChangeTimer: Timer?
    
    // MARK: ViewLifecycle
    
    override public func viewDidLoad() {
		super.viewDidLoad()
        // Setting the backgroundColor for the UIView of STLocationRequestController
        self.view.backgroundColor = self.backgroundColor
        // Add subviews
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.locationSymbolLabel)
        self.view.addSubview(self.allowButton)
        self.view.addSubview(self.notNowButton)
        // Add layers
        self.view.layer.insertSublayer(self.pulseEffect, below: self.locationSymbolLabel.layer)
        // Start rotating
        self.rotateMapCamera()
		// Start showing awesome places
		self.changeAwesomePlace(timer: nil)
		// Start the timer for changing location
        self.placeChangeTimer = Timer.scheduledTimer(
            timeInterval: self.timeTillPlaceSwitchesInSeconds,
            target: self,
            selector: #selector(changeAwesomePlace(timer:)),
            userInfo: nil,
            repeats: true
        )
	}

    override public func viewDidDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        // Invalidate timer
        self.placeChangeTimer?.invalidate()
        // Clear timer
        self.placeChangeTimer = nil
	}
    
    deinit {
        // Invalidate timer
        self.placeChangeTimer?.invalidate()
        // Clear timer
        self.placeChangeTimer = nil
    }
    
    // MARK: Layout
	
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Layout mapView
        self.mapView.frame = self.view.frame
        // Define constants
        let padding: CGFloat = 15.0
        let buttonHeight: CGFloat = 60.0
        // Layout descriptionLabel
        self.titleLabel.frame = CGRect(
            x: padding,
            y: padding * 2,
            width: self.view.frame.size.width - padding * 2,
            height: 150
        )
        // Layout notNowButton
        self.notNowButton.frame = CGRect(
            x: padding,
            y: self.view.frame.size.height - padding * 2 - buttonHeight,
            width: self.view.frame.size.width-padding * 2,
            height: buttonHeight
        )
        // Layout allowButton
        self.allowButton.frame = CGRect(
            x: padding,
            y: self.view.frame.size.height - buttonHeight * 2 - padding * 2.5,
            width: self.view.frame.size.width - padding * 2,
            height: buttonHeight
        )
        // Layout locationSymbolLabel
        let locationSymbolHeight = self.view.frame.size.height
            - self.titleLabel.frame.size.height
            - self.allowButton.frame.size.height
            - self.notNowButton.frame.size.height
            - padding * 6.5
        self.locationSymbolLabel.frame = CGRect(
            x: 0,
            y: self.view.center.y - locationSymbolHeight / 2,
            width: self.view.frame.size.width,
            height: locationSymbolHeight
        )
    }
    
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
			self.pulseEffect.setPulseRadius(self.pulseEffectRadius)
		}
	}
    
}

// MARK: Public functions

public extension STLocationRequestController {
    
    /**
     Function is deprecated. Please instantiate an object of STLocationRequestController.
     
     Example:
     ----
     ````
     let locationRequest = STLocationRequestController()
     ````
     */
    @available(*, deprecated, message: "getInstance() is no longer available. Instantiate a STLocationRequestController()")
    static func getInstance() -> STLocationRequestController {
        return STLocationRequestController()
    }
    
    /// Static function to retrieve an boolean if you should show the STLocationRequestController
    /// by evaluating if locationServices are enabled and authorizationStatus is notDetermined
    ///
    /// - Returns: Boolean if you should present the STLocationRequestController
    static func shouldPresentLocationRequestController() -> Bool {
        return CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .notDetermined
    }
    
    /**
     Present the STLocationRequestController modally on a given UIViewController
     
     iOS Simulator:
     ----
     Please mind that the 3D Flyover-View will only work on a **real** iOS Device **not** in the Simulator with at least iOS 9.0 installed
     
     - Parameter viewController: The `UIViewController` which will be used to present the STLocationRequestController modally.
     */
    func present(onViewController viewController: UIViewController, completion: (() -> Void)? = nil) {
        // Check if app is running on iOS Simulator
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            print("STLocationRequestController_WARNING☝️: Please keep in mind that the 3D-SatelliteFlyover only works on a real iOS Device and not on the iOS Simulator. Read more here -> https://github.com/SvenTiigi/STLocationRequest#ios-simulator")
        #endif
        // The STLocationRequestController is correctly initialized. Present the STLocationRequestController
        viewController.present(self, animated: true) {
            // After presenting the STLocationRequestController inform the delegate
            self.delegate?.locationRequestControllerDidChange(.didPresented)
            // Unwrap completion
            guard let completion = completion else {
                // No completion available return out of function
                return
            }
            // Call completion
            completion()
        }
    }
    
    /// Dismiss the STLocationRequestController
    func dismiss() {
        // Dismiss the STLocationRequestController
        self.dismiss(animated: true) {
            // Inform the delegate, that the STLocationRequestController is disappeared
            self.controllerUpdate(event: .didDisappear)
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
    func addPlace(coordinate place: CLLocationCoordinate2D) {
        self.customPlaces.append(place)
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
    func addPlace(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.addPlace(coordinate: coordinate)
    }
    
}

// MARK: Private functions

private extension STLocationRequestController {
    
    /// Change the current awesome place
    @objc func changeAwesomePlace(timer: Timer?) {
        // If the timer is not nil and there is only one place return the function
        if timer != nil && self.places.count == 1 {
            // Return out of function as there is only one place to show
            return
        }
        // Retrieve random place coorindate
        let placeCoordinate = self.getRandomPlaceCoordinate()
        // Set mapView region for place coordinate
        self.mapView.region = MKCoordinateRegionMakeWithDistance(
            placeCoordinate,
            self.mapViewCameraAltitude,
            self.mapViewCameraAltitude
        )
        // Set center coordinate for mapCamera by setting place coordinate
        self.mapCamera.centerCoordinate = placeCoordinate
        // Set mapView camera
        self.mapView.setCamera(self.mapCamera, animated: false)
        // Invoke mapView rotation
        self.rotateMapCamera()
    }
    
    /// Rotate the MapView camera
    func rotateMapCamera() {
        // Increase heading by heading step for mapCamera
        self.mapCamera.heading = fmod(self.mapCamera.heading + self.mapViewCameraHeadingStep, 360)
        // Animate MapView camera change
        UIView.animate(withDuration: self.mapViewCameraRotationAnimationDuration, delay: 0, options: [.curveLinear, .beginFromCurrentState], animations: {
            // Set mapView camera
            self.mapView.camera = self.mapCamera
        }) { (finished: Bool) in
            // Recursive invocation after completion
            finished ? self.rotateMapCamera() : ()
        }
    }
    
    /// Retrieve a random place coordinate
    ///
    /// - Returns: CLLocationCoordinate2D
    func getRandomPlaceCoordinate() -> CLLocationCoordinate2D {
        let generateRandomNumber = self.randomSequenceGenerator(0, max: self.places.count-1)
        return self.places[generateRandomNumber()]
    }
    
    /// Get a random Index from an given array without repeating an index
    ///
    /// - Parameters:
    ///   - min: min. value
    ///   - max: max. value
    /// - Returns: random integer (without a repeating random int)
    func randomSequenceGenerator(_ min: Int, max: Int) -> () -> Int {
        return {
            if self.randomNumbers.count == 0 {
                self.randomNumbers = Array(min...max)
            }
            let index = Int(arc4random_uniform(UInt32(self.randomNumbers.count)))
            return self.randomNumbers.remove(at: index)
        }
    }
    
    /// Controller update to an specific event.
    /// Invokes the onChange clousre and informs the delegate
    ///
    /// - Parameter event: The ControllerEvent
    func controllerUpdate(event: STLocationRequestControllerEvent) {
        // Check if an onChange closure is available
        if let onChange = self.onChange {
            // Call onChange with current event
            onChange(event)
        }
        // Invoke delegate for current event
        self.delegate?.locationRequestControllerDidChange(event)
    }
    
    // MARK: - Button Actions
    
    /// Allow button was touched request authorization by AuthorizeType
    @objc func allowButtonTouched() {
        // Switch on authorite type
        switch self.authorizeType {
        case .requestAlwaysAuthorization:
            // Request always
            self.locationManager.requestAlwaysAuthorization()
            break
        case .requestWhenInUseAuthorization:
            // Request when in use
            self.locationManager.requestWhenInUseAuthorization()
            break
        }
    }
    
    /// Not now button was touched dismiss Viewcontroller
    @objc func notNowButtonTouched() {
        // Update the Controller
        self.controllerUpdate(event: .notNowButtonTapped)
        // Dismiss Controller
        self.dismiss()
    }
    
}

// MARK: CLLocationManagerDelegate

extension STLocationRequestController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check the authorization state from CLLocationManager
        switch status {
        case .authorizedWhenInUse:
            self.controllerUpdate(event: .locationRequestAuthorized)
            self.dismiss()
            break
        case .authorizedAlways:
            self.controllerUpdate(event: .locationRequestAuthorized)
            self.dismiss()
            break
        case .denied:
            self.controllerUpdate(event: .locationRequestDenied)
            self.dismiss()
            break
        case .restricted:
            self.controllerUpdate(event: .locationRequestDenied)
            self.dismiss()
            break;
        case .notDetermined:
            break;
        }
    }
    
}
