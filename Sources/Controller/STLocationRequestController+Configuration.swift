//
//  STLocationRequestController+Configuration.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 14.01.18.
//

import UIKit
import CoreLocation
import Font_Awesome_Swift

public extension STLocationRequestController {
    
    /// The STLocationRequestController Configurations
    struct Configuration {
        
        /// The title which will be presented at the top of the STLocationRequestController.
        /// Default-Value: "We need your location for some awesome features"
        public var titleText = "We need your location for some awesome features"
        
        /// The title which will be presented at the top of the STLocationRequestController.
        /// Default-Value: UIFont.systemFontOfSize(25.0)
        public var titleFont: UIFont = .systemFont(ofSize: 25.0)
        
        /// The title for the allowButton which will trigger the requestWhenInUseAuthorization()
        /// or requestAlwaysAuthorization() Method on CLLocationManager. Default value is "Alright"
        public var allowButtonTitle = "Alright"
        
        /// The allowButton font. Default value is `systemFont(ofSize: 21)`
        public var allowButtonFont: UIFont = .systemFont(ofSize: 21)
        
        /// The background color when allow button is highlighted. Default value is `white`
        public var allowButtonHighlightedBackgroundColor: UIColor = .white
        
        /// The highlighted allow button title color.
        /// Default value is `UIColor.clear.withAlphaComponent(0.5)`
        public var allowButtonHighlightedTitleColor = UIColor.clear.withAlphaComponent(0.5)
        
        /// The title for the notNowButton which will dismiss the STLocationRequestController. Default value is "Not now"
        public var notNowButtonTitle = "Not now"
        
        /// The notNowButton font. Default value is `systemFont(ofSize: 21)`
        public var notNowButtonFont: UIFont = .systemFont(ofSize: 21)
        
        /// The background color when not now button is highlighted. Default value is `white`
        public var notNowButtonHighlightedBackgroundColor: UIColor = .white
        
        /// The highlighted not now button title color. Default value is `UIColor.clear.withAlphaComponent(0.5)`
        public var notNowButtonHighlightedTitleColor = UIColor.clear.withAlphaComponent(0.5)
        
        /// The alpha value for the MapView which is used in combination with `backgroundViewColor`
        /// to match the STLocationRequestController with the design of your app. Default value is 1
        public var mapViewAlpha: CGFloat = 1.0
        
        /// The MapView camera altitude. Default value is `600`
        public var mapViewCameraAltitude: CLLocationDistance = 600
        
        /// The MapView camera pitch. Default value is `45`
        public var mapViewCameraPitch: CGFloat = 45
        
        /// The MapView camera heading step. Default value is `20.0`
        public var mapViewCameraHeadingStep = 20.0
        
        /// The MapView camera animation duration. Default value is `4.0`
        public var mapViewCameraRotationAnimationDuration = 4.0
        
        /// The backgroundcolor for the view of the STLocationRequestController which is used
        /// in combination with `mapViewAlphaValue` to match the STLocationRequestController
        /// with the design of your app. Default value is a white color.
        public var backgroundColor: UIColor = .white
        
        /// Defines if the pulse Effect which will displayed under the location symbol should be enabled or disabled. Default Value: true
        public var isPulseEffectEnabled = true
        
        /// The color for the pulse effect behind the location symbol. Default value: white
        public var pulseEffectColor: UIColor = .white
        
        /// The pulse effect radius. Default value is `180`
        public var pulseEffectRadius: CGFloat = 180.0
        
        /// Set the location symbol icon which will be displayed in the middle of the location request screen.
        /// Default value: FAType.FALocationArrow. Which icons are available can
        /// be found on http://fontawesome.io/icons/ or https://github.com/Vaberer/Font-Awesome-Swift.
        public var locationSymbolIcon: FAType = .FALocationArrow
        
        /// The location symbol size. Default value is `150`
        public var locationSymbolSize: CGFloat = 150.0
        
        /// The color of the location symbol which will be presented in the middle of the location request screen. Default value: white
        public var locationSymbolColor: UIColor = .white
        
        /// Defines if the location symbol which will be presented in the middle of the location request screen is hidden. Default value: false
        public var isLocationSymbolHidden = false
        
        /// The StatusBarStyle. Default value: .lightContent
        public var statusBarStyle: UIStatusBarStyle = .lightContent
        
        /// Set the authorize Type for STLocationRequestController.
        /// Choose between: `.requestWhenInUseAuthorization` and `.requestAlwaysAuthorization`.
        /// Default value is `.requestWhenInUseAuthorization`
        public var authorizeType: Authorization = .requestWhenInUseAuthorization
        
        /// Set the in the interval for switching the shown places in seconds. Default value is 15 seconds
        public var timeTillPlaceSwitchesInSeconds: TimeInterval = 15.0
        
        /// Fill the optional value `placesFilter` if you wish to specify which places should be shown.
        /// Default value is "nil" which means all places will be shown
        public var placesFilter: [Place]?
        
        /// The custom Coordinates array
        public var customPlaces: [CLLocationCoordinate2D] = []
        
        /// Default initializer
        public init() {}
        
    }
    
}
