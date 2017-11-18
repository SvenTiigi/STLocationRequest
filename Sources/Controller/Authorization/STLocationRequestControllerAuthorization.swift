//
//  STLocationRequestControllerAuthorization.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 18.11.17.
//

import Foundation

/// Enum to decide which location request type should be used
@objc public enum STLocationRequestControllerAuthorizeType: Int {
    /// Location-Request when in use authorization
    case requestWhenInUseAuthorization
    /// Location-Request always authorization
    case requestAlwaysAuthorization
}
