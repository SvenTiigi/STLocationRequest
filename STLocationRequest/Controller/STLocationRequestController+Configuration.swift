//
//  STLocationRequestController+Configuration.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 14.01.18.
//

import UIKit
import MapKit
import SwiftIconFont

// MARK: Configuration

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
            font: .systemFont(ofSize: 21),
            highlightedBackgroundColor: .white,
            highlightedTitleColor: UIColor.clear.withAlphaComponent(0.5)
        )
        
        /// The NotNowButton which will dismiss the STLocationRequestController
        public var notNowButton: Button = (
            title: "Not now",
            font: .systemFont(ofSize: 21),
            highlightedBackgroundColor: .white,
            highlightedTitleColor: UIColor.clear.withAlphaComponent(0.5)
        )
        
        /// The MapView
        public var mapView: MapView = (
            type: .satelliteFlyover,
            alpha: 1.0,
            altitude: 600,
            pitch: 45,
            headingStep: 20.0,
            animationDuration: 4.0
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
            icon: .fontAwesome(code: "locationarrow"),
            size: 150,
            color: .white,
            hidden: false
        )
        
        /// The StatusBarStyle. Default value: .lightContent
        public var statusBarStyle: UIStatusBarStyle = .lightContent
        
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

// MAKR: Configuration TypeAlias

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
        font: UIFont,
        highlightedBackgroundColor: UIColor,
        highlightedTitleColor: UIColor
    )
    
    /// The MapView Configuration Type
    typealias MapView = (
        type: MKMapType,
        alpha: CGFloat,
        altitude: CLLocationDistance,
        pitch: CGFloat,
        headingStep: Double,
        animationDuration: Double
    )
    
    /// The PulseEffect Configuration Type
    typealias PulseEffect = (
        enabled: Bool,
        color: UIColor,
        radius: CGFloat
    )
    
    /// The LocationSymbol Configuration Type
    typealias LocationSymbol = (
        icon: SymbolIcon,
        size: CGFloat,
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

// MARK: SymbolIcon

public extension STLocationRequestController.Configuration {
    
    /// The SymbolIcon Enumeration
    enum SymbolIcon {
        /// FontAwesome
        case fontAwesome(code: String)
        /// Iconic
        case iconic(code: String)
        /// Ionicon
        case ionicon(code: String)
        /// Octicon
        case octicon(code: String)
        /// Themify
        case themify(code: String)
        /// MapIcon
        case mapIcon(code: String)
        /// MaterialIcon
        case materialIcon(code: String)
    }
    
}

// MARK: SymbolIcon.RawRepresentable

extension STLocationRequestController.Configuration.SymbolIcon: RawRepresentable {
    
    /// The raw type that can be used to represent all values of the conforming
    public typealias RawValue = (font: Fonts, icon: String?)
    
    /// Creates a new instance with the specified raw value.
    public init?(rawValue: RawValue) {
        // Return nil as no initialization via rawValue is supported
        return nil
    }
    
    /// /// The corresponding value of the raw type.
    public var rawValue: RawValue {
        /// Switch on self
        switch self {
        case .fontAwesome(let code):
            return (.FontAwesome, String.fontAwesomeIcon(code))
        case .iconic(code: let code):
            return (.Iconic, String.fontIconicIcon(code))
        case .ionicon(code: let code):
            return (.Ionicon, String.fontIonIcon(code))
        case .octicon(code: let code):
            return (.Octicon, String.fontOcticon(code))
        case .themify(code: let code):
            return (.Themify, String.fontThemifyIcon(code))
        case .mapIcon(code: let code):
            return (.MapIcon, String.fontMapIcon(code))
        case .materialIcon(code: let code):
            return (.MaterialIcon, String.fontMaterialIcon(code))
        }
    }
    
}
