//
//  STLocationRequestController+Authorization.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 18.11.17.
//

import Foundation

// MARK: - Authorization

public extension STLocationRequestController {
    
    /// Enum to decide which location request type should be used
    enum Authorization: String, Codable, Equatable, Hashable, CaseIterable {
        /// Location-Request when in use authorization
        case requestWhenInUseAuthorization
        #if os(iOS)
        /// Location-Request always authorization
        case requestAlwaysAuthorization
        #endif
    }
    
}
