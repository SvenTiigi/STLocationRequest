//
//  STLocationRequestControllerEvent.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 18.11.17.
//

import Foundation

public extension STLocationRequestController {
    
    /// STLocationRequestEvent Enum for events in the delegate Method locationRequestControllerDidChange
    @objc enum Event: Int {
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
