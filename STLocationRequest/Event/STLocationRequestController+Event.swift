//
//  STLocationRequestController+Event.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 18.11.17.
//

import CoreLocation

public extension STLocationRequestController {
    
    /// STLocationRequestEvent Enum for events in the delegate Method locationRequestControllerDidChange
    enum Event: Int {
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
    
}

// MARK: CLAuthorizationStatus toEvent() extension

extension CLAuthorizationStatus {
    
    /// Convert CLAuthorizationStatus to a STLocationRequestController.Event
    ///
    /// - Returns: The optional event conversion
    func toEvent() -> STLocationRequestController.Event? {
        switch self {
        case .authorizedWhenInUse:
            return .locationRequestAuthorized
        case .authorizedAlways:
            return .locationRequestAuthorized
        case .denied:
            return .locationRequestDenied
        case .restricted:
            return .locationRequestDenied
        case .notDetermined:
            // Not determined shouldn't be triggered
            // As we request location services
            return nil
        }
    }
    
}
