//
//  STLocationRequestController+Configuration.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 14.01.18.
//

import FlyoverKit
import MapKit
import UIKit

// MARK: - Configuration

public extension STLocationRequestController {
    
    /// The STLocationRequestController Configurations
    struct Configuration {
        
        /// The title which will be presented at the top of the STLocationRequestController
        public var title: Title = (
            text: "We need your location for some awesome features",
            font: .systemFont(ofSize: 25.0),
            color: .white
        )
        
        /// The AllowButton which will trigger the location request
        public var allowButton: Button = (
            title: "Alright",
            titleColor: .white,
            font: .systemFont(ofSize: 21),
            backgroundColor: UIColor.white.withAlphaComponent(0.08),
            highlightedBackgroundColor: .white,
            highlightedTitleColor: UIColor.clear.withAlphaComponent(0.5),
            borderColor: .white,
            borderWidth: 1.0,
            cornerRadius: 5.0
        )
        
        /// The NotNowButton which will dismiss the STLocationRequestController
        public var notNowButton: Button = (
            title: "Not now",
            titleColor: .white,
            font: .systemFont(ofSize: 21),
            backgroundColor: UIColor.white.withAlphaComponent(0.08),
            highlightedBackgroundColor: .white,
            highlightedTitleColor: UIColor.clear.withAlphaComponent(0.5),
            borderColor: .white,
            borderWidth: 1.0,
            cornerRadius: 5.0
        )
        
        /// The MapView
        public var mapView: MapView = (
            configuration: .default,
            type: .satelliteFlyover,
            alpha: 1.0
        )
        
        /// The backgroundcolor for the view of the STLocationRequestController
        public var backgroundColor: UIColor = .white
        
        /// The PulseEffect underneath the LocationSymbol
        public var pulseEffect: PulseEffect = (
            enabled: true,
            color: .white,
            radius: 180
        )
        
        /// The Location Symbol which will be displayed in the middle of the STLocationRequestController
        public var locationSymbol: LocationSymbol = (
            color: .white,
            hidden: false
        )
        
        #if os(iOS)
        /// The StatusBarStyle. Default value: .lightContent
        public var statusBarStyle: UIStatusBarStyle = .lightContent
        #endif
        
        /// Set the authorize Type for STLocationRequestController.
        /// Choose between: `.requestWhenInUseAuthorization` and `.requestAlwaysAuthorization`.
        /// Default value is `.requestWhenInUseAuthorization`
        public var authorizeType: Authorization = .requestWhenInUseAuthorization
        
        /// The Places
        public var places: Places = (
            filter: nil,
            changeInterval: 15,
            custom: []
        )
        
        /// Default initializer
        public init() {}
        
    }
    
}

// MAKR: - Configuration TypeAlias

public extension STLocationRequestController.Configuration {
    
    /// The Title Configuration Type
    typealias Title = (
        text: String,
        font: UIFont,
        color: UIColor
    )
    
    /// The Button Configuration Type
    typealias Button = (
        title: String,
        titleColor: UIColor,
        font: UIFont,
        backgroundColor: UIColor,
        highlightedBackgroundColor: UIColor,
        highlightedTitleColor: UIColor,
        borderColor: UIColor,
        borderWidth: CGFloat,
        cornerRadius: CGFloat
    )
    
    /// The MapView Configuration Type
    typealias MapView = (
        configuration: FlyoverCamera.Configuration,
        type: FlyoverMapView.MapType,
        alpha: CGFloat
    )
    
    /// The PulseEffect Configuration Type
    typealias PulseEffect = (
        enabled: Bool,
        color: UIColor,
        radius: CGFloat
    )
    
    /// The LocationSymbol Configuration Type
    typealias LocationSymbol = (
        color: UIColor,
        hidden: Bool
    )
    
    /// The Places Configuration Type
    typealias Places = (
        filter: [STLocationRequestController.Place]?,
        changeInterval: TimeInterval,
        custom: [CLLocationCoordinate2D]
    )
    
}
