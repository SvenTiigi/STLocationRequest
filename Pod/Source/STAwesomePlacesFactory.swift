//
//  STLandmarksLocationFactory.swift
//  Pods
//
//  Created by Sven Tiigi on 05.09.16.
//
//

import Foundation
import CoreLocation

/// Enumeration of coordinates from awesome places (Value = "LAT_LONG")
public enum STAwesomePlace : String {
    // MARK: USA
    case newYorkStatueOfLiberty = "40.689249_-74.044500"
    case newYork = "40.702749_-74.014120"
    case sanFranciscoGoldenGateBridge = "37.826040_-122.479448"
    case centralParkNY = "40.779269_-73.963201"
    case googlePlex = "37.422001_-122.084109"
    case miamiBeach = "25.791007_-80.148082"
    case lagunaBeach = "33.543361_-117.792315"
    case griffithObservatory = "34.118536_-118.300446"
    case luxorResortLasVegas = "36.095511_-115.176072"
    case appleHeadquarter = "37.332100_-122.029642"
    // MARK: Germany
    case berlinBrandenburgerGate = "52.516275_13.377704"
    case hamburgTownHall = "53.550416_9.992527"
    case cologneCathedral = "50.941278_6.958281"
    case munichCurch = "48.138631_11.573625"
    case neuschwansteinCastle = "47.557574_10.749800"
    case hamburgElbPhilharmonic = "53.541227_9.984075"
    case muensterCastle = "51.963691_7.611546"
    // MARK: Italy
    case romeColosseum = "41.89021_12.492231"
    case piazzaDiTrevi = "41.900865_12.483345"
    // MARK: Spain
    case sagradaFamiliaSpain = "41.404024_2.174370"
    // MARK: England
    case londonBigBen = "51.500729_-0.124625"
    case londonEye = "51.503324_-0.119543"
    // MARK: Australia
    case sydneyOperaHouse = "-33.857197_151.215140"
    // MARK: France
    case parisEiffelTower = "48.85815_2.29452"
}

/// STAwesomePlacesFactory generates Coordinates from awesome Places
struct STAwesomePlacesFactory {
    
    /// Return an array of CLLocationCoordiante2D with awesome places
    ///
    /// - Parameter filter: An array of STAwesomePlaces Enums which only should be added to the return array. If the parameter is nil all places will be added to the return array.
    /// - Returns: CLLocationCoordinate2D Array of awesome places
    static func getAwesomePlaces(withPlacesFilter filter : [STAwesomePlace]?) -> [CLLocationCoordinate2D]{
        // Initialize the CLLocationCoordinate2D Array
        var places: [CLLocationCoordinate2D] = []
        // Iterate through all STAwesomePlaces Enums
        for awesomePlace in iterateEnum(STAwesomePlace.self) {
            // Check if the placesFilter is nil
            if let placesFilter = filter {
                // The placesFilter is set. Check if the placesFilter contains the current STAwesomePlace Enum
                if placesFilter.contains(awesomePlace) {
                    // Add the Coordinate from the current STAwesomePlace Enum to the places Array
                    if let coordinate = getCoordinate(fromAwesomePlace: awesomePlace) {
                        places.append(coordinate)
                    }
                }
            } else {
                // The placesFilter was not set add the current STAwesomePlace Enum coordinate to the places array
                if let coordinate = getCoordinate(fromAwesomePlace: awesomePlace) {
                    places.append(coordinate)
                }
            }

        }
        // Return the places array
        return places
    }
    
    /// Get coordinate from STAwesomePlace Enum
    ///
    /// - Parameter awesomePlace: STAwesomePlace Enum
    /// - Returns: CLLocationCoordinate2D of STAwesomePlace Enum
    private static func getCoordinate(fromAwesomePlace awesomePlace : STAwesomePlace) -> CLLocationCoordinate2D? {
        let awesomePlaceCoordinatesText = awesomePlace.rawValue.components(separatedBy: "_")
        guard let latitudeText = awesomePlaceCoordinatesText.first, let longitudeText = awesomePlaceCoordinatesText.last else {
            return nil
        }
        guard let latitude = Double(latitudeText), let longitude = Double(longitudeText) else {
            return nil
        }
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    /// Private helper function to iterate all values of an enum
    ///
    /// - Parameter _: Enumeration
    /// - Returns: Iterator for the enumeration
    private static func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafePointer(to: &i) {
                $0.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
            }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
    
}
