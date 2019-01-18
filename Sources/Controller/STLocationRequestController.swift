//
//  STLocationRequestController.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 02.12.15.
//

import FlyoverKit
import MapKit
import UIKit

// MARK: - STLocationRequestController

/// STLocationRequest is a UIViewController-Extension which is used
/// to request the User-Location, at the very first time, in a simple and elegent way.
/// It shows a beautiful 3D 360 degree Flyover-MapView which shows 14 random citys or landmarks.
public class STLocationRequestController: UIViewController {
    
    // MARK: Static Properties
    
    /// Evaluates if locationServices are enabled and authorizationStatus is notDetermined
    public static var shouldPresentLocationRequestController: Bool {
        return CLLocationManager.locationServicesEnabled()
            && CLLocationManager.authorizationStatus() == .notDetermined
    }
    
    // MARK: Public Properties
    
    /// The optional onEvent closure to be notified
    /// if an STLocationRequestController.Event occured
    public var onEvent: ((Event) -> Void)?
    
    #if os(iOS)
    /// The preferredStatusBarStyle
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.configuration.statusBarStyle
    }
    #endif
    
    // MARK: Private properties
    
    /// The configuration
    private var configuration: Configuration
    
    /// The PlaceChanger
    private lazy var placeChanger: PlaceChanger = {
        return PlaceChanger(
            placesConfiguration: self.configuration.places,
            onChangePlace: self.flyoverMapView.start
        )
    }()
    
    /// The Allow-Button
    private lazy var allowButton: Button = {
        return Button(
            configurationButton: self.configuration.allowButton,
            target: self,
            action: #selector(allowButtonTouched)
        )
    }()
    
    /// The Not-Now-Button
    private lazy var notNowButton: Button = {
        return Button(
            configurationButton: self.configuration.notNowButton,
            target: self,
            action: #selector(notNowButtonTouched)
        )
    }()
    
    /// The FlyoverMapView
    private lazy var flyoverMapView: FlyoverMapView = {
        let mapView = FlyoverMapView(
            configuration: self.configuration.mapView.configuration,
            mapType: self.configuration.mapView.type
        )
        mapView.alpha = self.configuration.mapView.alpha
        return mapView
    }()
    
    /// TitleLabel
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = self.configuration.title.text
        label.textAlignment = .center
        label.font = self.configuration.title.font
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = self.configuration.title.color
        label.shadowColor = UIColor(red: 108/255, green: 108/255, blue: 108/255, alpha: 1)
        label.shadowOffset = CGSize(width: 0, height: 1)
        return label
    }()
    
    /// Location Symbol Label
    private lazy var locationSymbolLabel: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        let image = UIImage(
            named: "LocationSymbol.png",
            in: Bundle(for: type(of: self)),
            compatibleWith: nil
        )
        if self.configuration.locationSymbol.color == .white {
            view.image = image
        } else {
            let templateImage = image?.withRenderingMode(.alwaysTemplate)
            view.image = templateImage
            view.tintColor = self.configuration.locationSymbol.color
        }
        return view
    }()
    
    /// The pulse effect
    private lazy var pulseEffect: LFTPulseAnimation = {
        let pulseEffect = LFTPulseAnimation(
            repeatCount: Float.infinity,
            radius: self.configuration.pulseEffect.radius,
            position: self.view.center
        )
        pulseEffect.backgroundColor = self.configuration.pulseEffect.color.cgColor
        pulseEffect.isHidden = !self.configuration.pulseEffect.enabled
        return pulseEffect
    }()

    /// CLLocationManager
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    // MARK: Initializers
    
    /// Designated initializer with Configuration object
    ///
    /// - Parameter configuration: The configuration
    public init(configuration: Configuration) {
        // Set configuration
        self.configuration = configuration
        // Super Init
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
    
    /// This initializer is not supported and will return nil
    /// Please use the configuration initializers
    public required init?(coder aDecoder: NSCoder) {
        // No support for initialization with NSCoder
        return nil
    }
    
    /// Deinit
    deinit {
        // Perform CleanUp
        self.cleanUp()
    }
    
    // MARK: View-Lifecycle
    
    /// ViewDidLoad
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Setting the backgroundColor for the UIView of STLocationRequestController
        self.view.backgroundColor = self.configuration.backgroundColor
        // Add subviews
        [self.flyoverMapView,
         self.titleLabel,
         self.locationSymbolLabel,
         self.allowButton,
         self.notNowButton].forEach(self.view.addSubview)
        // Add Constraints
        self.addConstraints()
        // Add layers
        self.view.layer.insertSublayer(self.pulseEffect, below: self.locationSymbolLabel.layer)
        // Check orientation
        self.checkOrientation()
        // Start place changer
        self.placeChanger.start()
    }
    
    /// ViewDidDisappear
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Perform CleanUp
        self.cleanUp()
    }
    
    var frame: CGRect {
        return self.view.frame
    }
    
    /// ViewDidLayoutSubviews
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Recenter pulseEffect Layer
        self.pulseEffect.position = self.view.center
        // Set MapView to full frame size
        self.flyoverMapView.frame = self.view.frame
    }
    
    /// ViewWillTransition toSize
    override public func viewWillTransition(to size: CGSize,
                                            with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.checkOrientation()
    }
    
    // MARK: Constraints
    
    /// Add Constraints
    private func addConstraints() {
        // TitleLabel Constraints
        NSLayoutConstraint.activate(on: self.titleLabel, [
            self.titleLabel.topAnchor.constraint(equalTo: self.anchor.topAnchor, constant: 15),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.anchor.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.anchor.trailingAnchor),
            self.titleLabel.widthAnchor.constraint(equalTo: self.anchor.widthAnchor)
        ])
        // NotNowButton Constraints
        NSLayoutConstraint.activate(on: self.notNowButton, [
            self.notNowButton.leadingAnchor.constraint(equalTo: self.anchor.leadingAnchor, constant: 15),
            self.notNowButton.trailingAnchor.constraint(equalTo: self.anchor.trailingAnchor, constant: -15),
            self.notNowButton.heightAnchor.constraint(equalToConstant: 60),
            self.notNowButton.bottomAnchor.constraint(equalTo: self.anchor.bottomAnchor, constant: -30)
        ])
        // AllowButton Constraints
        NSLayoutConstraint.activate(on: self.allowButton, [
            self.allowButton.bottomAnchor.constraint(equalTo: self.notNowButton.topAnchor, constant: -10),
            self.allowButton.leadingAnchor.constraint(equalTo: self.anchor.leadingAnchor, constant: 15),
            self.allowButton.trailingAnchor.constraint(equalTo: self.anchor.trailingAnchor, constant: -15),
            self.allowButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        // LocationSymbolLabel Constraints
        NSLayoutConstraint.activate(on: self.locationSymbolLabel, [
            self.locationSymbolLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.locationSymbolLabel.centerXAnchor.constraint(equalTo: self.anchor.centerXAnchor, constant: -5),
            self.locationSymbolLabel.centerYAnchor.constraint(equalTo: self.anchor.centerYAnchor),
            self.locationSymbolLabel.bottomAnchor.constraint(equalTo: self.allowButton.topAnchor, constant: -10)
        ])
    }
    
}

// MARK: - Public API Present/Dismiss functions

public extension STLocationRequestController {
    
    /// Present the STLocationRequestController modally on a given UIViewController.
    /// Please keep in mind that the 3D Flyover-View will only work on a **real** iOS Device **not** in the Simulator.
    ///
    /// - Parameters:
    ///   - viewController: The ViewController which will be used to present the STLocationRequestController modally.
    ///   - completion: When the STLocationRequestController has been presented
    func present(onViewController viewController: UIViewController, completion: (() -> Void)? = nil) {
        // The STLocationRequestController is correctly initialized. Present the STLocationRequestController
        viewController.present(self, animated: true) {
            // Invoke controller update
            self.onEvent?(.didPresented)
            // Invoke completion
            completion?()
        }
    }
    
    /// Dismiss the STLocationRequestController
    func dismiss(completion: (() -> Void)? = nil) {
        // Dismiss the STLocationRequestController
        self.dismiss(animated: true) {
            // Inform the delegate, that the STLocationRequestController is disappeared
            self.onEvent?(.didDisappear)
            // Invoke completion
            completion?()
        }
    }
    
}

// MARK: - Private API

private extension STLocationRequestController {
    
    /// Clean up the STLocationRequestController
    func cleanUp() {
        // Stop place changer
        self.placeChanger.stop()
        // Stop Rotation
        self.flyoverMapView.stop()
    }
    
    /// Check device orientation
    func checkOrientation() {
        #if os(iOS)
        // Check if current Device is not phone type
        if UIDevice.current.userInterfaceIdiom != .phone {
            // Return out of function
            return
        }
        // Initialize isLandscape orientation
        let isLandscape = UIDevice.current.orientation.isLandscape
        // Perform animation fade-in/fade-out
        UIView.animate(withDuration: 0.5) {
            self.locationSymbolLabel.alpha = isLandscape ? 1 : 0
            self.locationSymbolLabel.alpha = isLandscape ? 0 : 1
        }
        // Set pulse radius
        self.pulseEffect.setPulseRadius(isLandscape ? 0 : self.configuration.pulseEffect.radius)
        #endif
    }
    
    /// Allow button was touched request authorization by AuthorizeType
    @objc func allowButtonTouched() {
        // Switch on authorite type
        switch self.configuration.authorizeType {
        #if os(iOS)
        case .requestAlwaysAuthorization:
            // Request always
            self.locationManager.requestAlwaysAuthorization()
        #endif
        case .requestWhenInUseAuthorization:
            // Request when in use
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    /// Not now button was touched dismiss Viewcontroller
    @objc func notNowButtonTouched() {
        // Update the Controller
        self.onEvent?(.notNowButtonTapped)
        // Dismiss Controller
        self.dismiss()
    }
    
}

// MARK: - CLLocationManagerDelegate

extension STLocationRequestController: CLLocationManagerDelegate {
    
    /// LocationManager didChangeAuthorizationStatus
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check if Event is available
        guard let event = status.toEvent() else {
            // Return out of function no event to emit
            return
        }
        // Emit Event
        self.onEvent?(event)
        // Dismiss
        self.dismiss()
    }
    
}
