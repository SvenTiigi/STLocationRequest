//
//  STLocationRequestControllerDelegate.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 18.11.17.
//

import Foundation

/// STLocationRequest Delegate
@objc public protocol STLocationRequestControllerDelegate {
    /**
     STLocationRequestControllerDelegate which is used to handle events from the STLocationRequestController.
     - Parameter event: Enum which contains the event of STLocationRequestControllerEvent
     Example usage:
     ----
     ````
     func locationRequestControllerDidChange(event: STLocationRequestControllerEvent) {
        switch event {
        case .locationRequestAuthorized:
            break
        case .locationRequestDenied:
            break
        case .notNowButtonTapped:
            break
        case .didPresented:
            break
        case .didDisappear:
            break
        }
     }
     ````
     */
    @objc func locationRequestControllerDidChange(_ event: STLocationRequestControllerEvent)
}
