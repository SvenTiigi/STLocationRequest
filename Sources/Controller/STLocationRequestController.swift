//
//  STLocationRequestController.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 02.12.15.
//

import UIKit
import MapKit
import SnapKit

/// STLocationRequest is a UIViewController-Extension which is used to request the User-Location, at the very first time, in a simple and elegent way.
/// It shows a beautiful 3D 360 degree Flyover-MapView which shows 14 random citys or landmarks.
public class STLocationRequestController: UIViewController {
    
    // MARK: Static Properties
    
    /// Evaluates if locationServices are enabled and authorizationStatus is notDetermined
    public static var shouldPresentLocationRequestController: Bool {
        return CLLocationManager.locationServicesEnabled()
            && CLLocationManager.authorizationStatus() == .notDetermined
    }
    
    // MARK: Public Properties
    
    /// The optional onChange closure to be notified
    /// if an STLocationRequestController.Event occured
    public var onChange: ((Event) -> Void)?
    
    /// The preferredStatusBarStyle
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.configuration.statusBarStyle
    }
    
    // MARK: Private properties
    
    /// The configuration
    private var configuration: Configuration
    
    /// The Allow-Button
    lazy private var allowButton: Button = {
        let button = Button(
            title: self.configuration.allowButtonTitle,
            font: self.configuration.allowButtonFont,
            highlightedBackgroundColor: self.configuration.allowButtonHighlightedBackgroundColor,
            highlightedTitleColor: self.configuration.allowButtonHighlightedTitleColor,
            target: self,
            action: #selector(allowButtonTouched)
        )
        return button
    }()
    
    /// The Not-Now-Button
    lazy private var notNowButton: Button = {
        let button = Button(
            title: self.configuration.notNowButtonTitle,
            font: self.configuration.notNowButtonFont,
            highlightedBackgroundColor: self.configuration.notNowButtonHighlightedBackgroundColor,
            highlightedTitleColor: self.configuration.notNowButtonHighlightedTitleColor,
            target: self,
            action: #selector(notNowButtonTouched)
        )
        return button
    }()
    
    /// The MapView
    lazy private var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = self.configuration.mapViewType
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.alpha = self.configuration.mapViewAlpha
        return mapView
    }()
    
    /// TitleLabel
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.configuration.titleText
        label.textAlignment = .center
        label.font = self.configuration.titleFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        label.shadowColor = UIColor(red: 108/255, green: 108/255, blue: 108/255, alpha: 1)
        label.shadowOffset = CGSize(width: 0, height: 1)
        return label
    }()
    
    /// Location Symbol Label
    lazy private var locationSymbolLabel: UILabel = {
        let label = UILabel()
        label.isHidden = self.configuration.isLocationSymbolHidden
        label.setFAIcon(icon: self.configuration.locationSymbolIcon, iconSize: self.configuration.locationSymbolSize)
        label.textColor = self.configuration.locationSymbolColor
        label.textAlignment = .center
        return label
    }()
    
    /// The pulse effect
    lazy private var pulseEffect: LFTPulseAnimation = {
        let pulseEffect = LFTPulseAnimation(
            repeatCount: Float.infinity,
            radius:self.configuration.pulseEffectRadius,
            position:self.view.center
        )
        pulseEffect.backgroundColor = self.configuration.pulseEffectColor.cgColor
        pulseEffect.isHidden = !self.configuration.isPulseEffectEnabled
        return pulseEffect
    }()
    
    /// Places Coordinate array
    lazy private var places: [CLLocationCoordinate2D] = {
        return Place.getPlaces(
            withPlacesFilter: self.configuration.placesFilter,
            andCustomPlaces: self.configuration.customPlaces
        )
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
    
    /// The rotating map camera
    lazy private var rotatingMapCamera: RotatingMapCamera = {
        return RotatingMapCamera(
            mapView: self.mapView,
            duration: self.configuration.mapViewCameraRotationAnimationDuration,
            altitude: self.configuration.mapViewCameraAltitude,
            pitch: self.configuration.mapViewCameraPitch,
            headingStep: self.configuration.mapViewCameraHeadingStep
        )
    }()
    
    /// The place change timer
    private var placeChangeTimer: Timer?
    
    // MARK: Initializers
    
    /// Default initializer with Configuration object
    ///
    /// - Parameter configuration: The configuration
    public init(configuration: Configuration) {
        // Set configuration
        self.configuration = configuration
        // Init
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Convenience initializer with Configuration Closure
    ///
    /// - Parameter configuration: The Configuration Closure
    public convenience init(configuration: (inout Configuration) -> Void) {
        // Initialize Configuration
        var config = Configuration()
        // Perform Configuration
        configuration(&config)
        // Init with config
        self.init(configuration: config)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewLifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Setting the backgroundColor for the UIView of STLocationRequestController
        self.view.backgroundColor = self.configuration.backgroundColor
        // Add subviews
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.locationSymbolLabel)
        self.view.addSubview(self.allowButton)
        self.view.addSubview(self.notNowButton)
        // Layout subview
        self.layoutSubviews()
        // Add layers
        self.view.layer.insertSublayer(self.pulseEffect, below: self.locationSymbolLabel.layer)
        // Initial change place
        self.changePlace(timer: nil)
        // Start the timer for changing the place
        self.placeChangeTimer = Timer.scheduledTimer(
            timeInterval: self.configuration.timeTillPlaceSwitchesInSeconds,
            target: self,
            selector: #selector(changePlace(timer:)),
            userInfo: nil,
            repeats: true
        )
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Perform CleanUp
        self.cleanUp()
    }
    
    deinit {
        // Perform CleanUp
        self.cleanUp()
    }
    
    // MARK: Layout
    
    /// Layout Subview
    private func layoutSubviews() {
        // MapView
        self.mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        // TitleLabel
        self.titleLabel.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(15)
            } else {
                make.top.equalTo(self.view).offset(15)
            }
            if #available(iOS 11.0, *) {
                make.width.equalTo(self.view.safeAreaLayoutGuide.snp.width)
            } else {
                make.width.equalTo(self.view)
            }
        }
        // NotNowButton
        self.notNowButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(15)
                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            } else {
                make.left.right.equalTo(self.view).offset(15).inset(15)
            }
            make.height.equalTo(60)
            make.bottom.equalTo(self.view).inset(30)
        }
        // AllowButton
        self.allowButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.notNowButton.snp.top).offset(-10)
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(15)
                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(15)
            } else {
                make.left.right.equalTo(self.view).offset(15).inset(15)
            }
            make.height.equalTo(60)
        }
        // LocationSymbolLabel
        self.locationSymbolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            if #available(iOS 11.0, *) {
                make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left)
                make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right)
            } else {
                make.left.right.equalTo(self.view)
            }
            make.centerY.centerX.equalTo(self.view)
            make.bottom.equalTo(self.allowButton.snp.top).offset(-10)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Recenter pulseEffect Layer
        self.pulseEffect.position = self.view.center
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Check if current Device is not phone type
        if UIDevice.current.userInterfaceIdiom != .phone {
            // Return out of function
            return
        }
        // Check orientation
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
            self.pulseEffect.setPulseRadius(self.configuration.pulseEffectRadius)
        }
    }
    
}

// MARK: Present/Dismiss functions

public extension STLocationRequestController {
    
    /// Present the STLocationRequestController modally on a given UIViewController.
    /// Please keep in mind that the 3D Flyover-View will only work on a **real** iOS Device **not** in the Simulator.
    ///
    /// - Parameters:
    ///   - viewController: The `UIViewController` which will be used to present the STLocationRequestController modally.
    ///   - completion: When the STLocationRequestController has been presented
    func present(onViewController viewController: UIViewController, completion: (() -> Void)? = nil) {
        // The STLocationRequestController is correctly initialized. Present the STLocationRequestController
        viewController.present(self, animated: true) {
            // Invoke controller update
            self.emit(event: .didPresented)
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
    func dismiss(completion: (() -> Void)? = nil) {
        // Dismiss the STLocationRequestController
        self.dismiss(animated: true) {
            // Inform the delegate, that the STLocationRequestController is disappeared
            self.emit(event: .didDisappear)
            // Unwrap completion
            guard let completion = completion else {
                // No completion available return out of function
                return
            }
            // Call completion
            completion()
        }
    }
    
}

// MARK: Private helper functions

private extension STLocationRequestController {
    
    /// Clean up the STLocationRequestController
    func cleanUp() {
        // Invalidate timer
        self.placeChangeTimer?.invalidate()
        // Clear timer
        self.placeChangeTimer = nil
        // Stop Rotation
        self.rotatingMapCamera.stop()
    }
    
    /// Emit an STLocationRequestController.Event
    ///
    /// - Parameter event: The Event
    func emit(event: Event) {
        // Check if an onChange closure is available
        if let onChange = self.onChange {
            // Call onChange with given event
            onChange(event)
        }
    }
    
}

// MARK: Change/Rotate MapView Place

private extension STLocationRequestController {
    
    /// Change the current place
    @objc func changePlace(timer: Timer?) {
        // If the timer is not nil and there is only one place return the function
        if timer != nil && self.places.count == 1 {
            // Return out of function as there is only one place to show
            return
        }
        // Retrieve random index
        let randomIndex = self.randomSequenceGenerator(0, max: self.places.count - 1)()
        // Retrieve random place coorindate
        let placeCoordinate = self.places[randomIndex]
        // Start Rotating MapView Camera for place coordinate
        self.rotatingMapCamera.start(lookingAt: placeCoordinate, animated: false)
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
    
}

// MARK: Button Action Handler

private extension STLocationRequestController {
    
    /// Allow button was touched request authorization by AuthorizeType
    @objc func allowButtonTouched() {
        // Switch on authorite type
        switch self.configuration.authorizeType {
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
        self.emit(event: .notNowButtonTapped)
        // Dismiss Controller
        self.dismiss()
    }
    
}

// MARK: CLLocationManagerDelegate

extension STLocationRequestController: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check if Event is available
        guard let event = status.toEvent() else {
            // Return out of function no event to emit
            return
        }
        // Emit Event
        self.emit(event: event)
        // Dismiss
        self.dismiss()
    }
    
}
