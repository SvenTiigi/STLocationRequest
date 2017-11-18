//
//  STLocationRequestPlaceFactory.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 18.11.17.
//

import Foundation
import CoreLocation

/// STAwesomePlacesFactory generates Coordinates from awesome Places
public struct STLocationRequestPlaceFactory {
    
    /// Return an array of CLLocationCoordiante2D with awesome places
    ///
    /// - Parameter filter: An array of STAwesomePlaces Enums which only should be added to the return array. If the parameter is nil all places will be added to the return array.
    /// - Returns: CLLocationCoordinate2D Array of awesome places
    public static func getPlaces(withPlacesFilter filter: [STLocationRequestPlace]?, andCustomPlaces customPlaces: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D]{
        // Initialize the CLLocationCoordinate2D Array
        var places: [CLLocationCoordinate2D] = []
        // Iterate through all STAwesomePlaces Enums
        for place in STLocationRequestPlace.iterate() {
            // If the current iteration is customPlaces continue
            if place == .customPlaces {
                continue
            }
            // Check if the placesFilter is available and place is not covered by filter
            if let placesFilter = filter, !placesFilter.contains(place) {
                // Continue as place shouldn't be used
                continue
            } else {
                // Append coordinate from place
                places.append(place.rawValue)
            }
        }
        // Check if a filter is set and if true check if customPlaces should be shown
        if let filter = filter {
            if !filter.contains(.customPlaces) {
                return places
            }
        }
        // Check if customPlaces are available
        guard customPlaces.count > 0 else {
            return places
        }
        // Append contents of customPlaces
        places.append(contentsOf: customPlaces)
        // Return the places array
        return places
    }
    
}
