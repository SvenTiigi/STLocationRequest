//
//  STLocationRequestPlace.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 18.11.17.
//

import Foundation
import CoreLocation

public extension STLocationRequestController {
    
    /// The STLocationRequestController.Place
    enum Place: Int {
        // MARK: USA
        case newYorkStatueOfLiberty
        case newYork
        case sanFranciscoGoldenGateBridge
        case centralParkNY
        case googlePlex
        case miamiBeach
        case lagunaBeach
        case griffithObservatory
        case luxorResortLasVegas
        case appleHeadquarter
        // MARK: Germany
        case berlinBrandenburgerGate
        case hamburgTownHall
        case cologneCathedral
        case munichCurch
        case neuschwansteinCastle
        case hamburgElbPhilharmonic
        case muensterCastle
        // MARK: Italy
        case romeColosseum
        case piazzaDiTrevi
        // MARK: Spain
        case sagradaFamiliaSpain
        // MARK: England
        case londonBigBen
        case londonEye
        // MARK: Australia
        case sydneyOperaHouse
        // MARK: France
        case parisEiffelTower
        // MARK: Custom Places
        case customPlaces
    }

}


// MARK: RawRepresentable

extension STLocationRequestController.Place: RawRepresentable {
    
    /// Associated type RawValue as CLLocationCoordinate2D
    public typealias RawValue = CLLocationCoordinate2D
    
    /// RawRepresentable initializer. Which always returns nil
    ///
    /// - Parameters:
    ///   - rawValue: The rawValue
    public init?(rawValue: RawValue) {
        // Returning nil to avoid constructing enum with RawValue
        return nil
    }
    
    /// The enumeration name as String
    public var rawValue: RawValue {
        switch self {
        case .newYorkStatueOfLiberty:
            return CLLocationCoordinate2D(latitude: 40.689249, longitude: -74.044500)
        case .newYork:
            return CLLocationCoordinate2D(latitude: 40.702749, longitude: -74.014120)
        case .sanFranciscoGoldenGateBridge:
            return CLLocationCoordinate2D(latitude: 37.826040, longitude: -122.479448)
        case .centralParkNY:
            return CLLocationCoordinate2D(latitude: 40.779269, longitude: -73.963201)
        case .googlePlex:
            return CLLocationCoordinate2D(latitude: 37.422001, longitude: -122.084109)
        case .miamiBeach:
            return CLLocationCoordinate2D(latitude: 25.791007, longitude: -80.148082)
        case .lagunaBeach:
            return CLLocationCoordinate2D(latitude: 33.543361, longitude: -117.792315)
        case .griffithObservatory:
            return CLLocationCoordinate2D(latitude: 34.118536, longitude: -118.300446)
        case .luxorResortLasVegas:
            return CLLocationCoordinate2D(latitude: 36.095511, longitude: -115.176072)
        case .appleHeadquarter:
            return CLLocationCoordinate2D(latitude: 37.332100, longitude: -122.029642)
        case .berlinBrandenburgerGate:
            return CLLocationCoordinate2D(latitude: 52.516275, longitude: 13.377704)
        case .hamburgTownHall:
            return CLLocationCoordinate2D(latitude: 53.550416, longitude: 9.992527)
        case .cologneCathedral:
            return CLLocationCoordinate2D(latitude: 50.941278, longitude: 6.958281)
        case .munichCurch:
            return CLLocationCoordinate2D(latitude: 48.138631, longitude: 11.573625)
        case .neuschwansteinCastle:
            return CLLocationCoordinate2D(latitude: 47.557574, longitude: 10.749800)
        case .hamburgElbPhilharmonic:
            return CLLocationCoordinate2D(latitude: 53.541227, longitude: 9.984075)
        case .muensterCastle:
            return CLLocationCoordinate2D(latitude: 51.963691, longitude: 7.611546)
        case .romeColosseum:
            return CLLocationCoordinate2D(latitude: 41.89021, longitude: 12.492231)
        case .piazzaDiTrevi:
            return CLLocationCoordinate2D(latitude: 41.900865, longitude: 12.483345)
        case .sagradaFamiliaSpain:
            return CLLocationCoordinate2D(latitude: 41.404024, longitude: 2.174370)
        case .londonBigBen:
            return CLLocationCoordinate2D(latitude: 51.500729, longitude: -0.124625)
        case .londonEye:
            return CLLocationCoordinate2D(latitude: 51.503324, longitude: -0.119543)
        case .sydneyOperaHouse:
            return CLLocationCoordinate2D(latitude: -33.857197, longitude: 151.215140)
        case .parisEiffelTower:
            return CLLocationCoordinate2D(latitude: 48.85815, longitude: 2.29452)
        case .customPlaces:
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
    
}

// MARK: Retrieve Places

public extension STLocationRequestController.Place {
    
    /// Return an array of CLLocationCoordiante2D with awesome places
    ///
    /// - Parameter filter: An array of STAwesomePlaces Enums which only should be added to the return array. If the parameter is nil all places will be added to the return array.
    /// - Returns: CLLocationCoordinate2D Array of awesome places
    static func getPlaces(withPlacesFilter filter: [STLocationRequestController.Place]?,
                          andCustomPlaces customPlaces: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D]{
        // Initialize the CLLocationCoordinate2D Array
        var places: [CLLocationCoordinate2D] = []
        // Iterate through all STAwesomePlaces Enums
        for place in STLocationRequestController.Place.iterate() {
            // If the current iteration is customPlaces
            if place == .customPlaces {
                // Continue with next place
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
    
    /// Private helper function to iterate all values of an enum
    ///
    /// - Returns: Iterator for the enumeration
    private static func iterate() -> AnyIterator<STLocationRequestController.Place> {
        var i = 0
        return AnyIterator {
            let next = withUnsafePointer(to: &i) {
                $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee }
            }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
    
}
