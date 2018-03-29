//
//  STLocationRequestController+PlaceChanger.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 25.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import CoreLocation

extension STLocationRequestController {
    
    /// ChangePlace function typealias
    typealias ChangePlace = (CLLocationCoordinate2D) -> Void
    
    /// The PlaceChanger
    class PlaceChanger {
        
        // MARK: Properties
        
        /// The places configuration
        private let placesConfiguration: STLocationRequestController.Configuration.Places
        
        /// OnChangePlace Closure
        private let onChangePlace: ChangePlace
        
        /// The random numbers array
        private var randomNumbers: [Int]
        
        /// The timer
        private var timer: Timer?
        
        /// The places
        private lazy var places: [CLLocationCoordinate2D] = {
            // Initialize Places by iterate Place enumeration with filter
            var places = STLocationRequestController.Place.iterate().compactMap { (place) -> CLLocationCoordinate2D? in
                // If the current iteration is customPlaces
                if place == .customPlaces {
                    return nil
                }
                // Check if the placesFilter is available and place is not covered by filter
                if let filter = self.placesConfiguration.filter, !filter.contains(place) {
                    return nil
                } else {
                    return place.rawValue
                }
            }
            // Check if a filter is set
            if let filter = self.placesConfiguration.filter {
                // Check if no customPlaces are applied as filter
                if !filter.contains(.customPlaces) {
                    // Return initialized palces
                    return places
                }
            }
            // Check if customPlaces are available
            guard !self.placesConfiguration.custom.isEmpty else {
                // Custom Places are available return places
                return places
            }
            // Append contents of customPlaces
            places.append(contentsOf: self.placesConfiguration.custom)
            // Return the places array
            return places
        }()
        
        // MARK: Initializer
        
        /// Default initializer with places configuration and onChangePlace closure
        ///
        /// - Parameters:
        ///   - placesConfiguration: The places configration
        ///   - onChangePlace: The onChangePlace closure
        init(placesConfiguration: STLocationRequestController.Configuration.Places,
             onChangePlace: @escaping ChangePlace) {
            // Set place configuration
            self.placesConfiguration = placesConfiguration
            // Set onChangePlace closure
            self.onChangePlace = onChangePlace
            // Initialize RandomNumbers array
            self.randomNumbers = []
        }
        
        // MARK: API
        
        /// Start PlaceChanger
        func start() {
            // Invoke initial changePlace
            self.changePlace(timer: nil)
            // Initialize Timer
            self.timer = Timer.scheduledTimer(
                timeInterval: self.placesConfiguration.changeInterval,
                target: self,
                selector: #selector(changePlace(timer:)),
                userInfo: nil,
                repeats: true
            )
        }
        
        /// Stop PlaceChanger
        func stop() {
            // Invalidate timer
            self.timer?.invalidate()
            // Clear timer
            self.timer = nil
        }
        
        // MARK: Private API
        
        /// Change place with random selected place
        ///
        /// - Parameter timer: The timer
        @objc private func changePlace(timer: Timer?) {
            // If the timer is not nil and there is only one place return the function
            if timer != nil && self.places.count == 1 {
                // Return out of function as there is only one place to show
                return
            }
            // Retrieve random index
            let randomIndex = self.randomSequenceGenerator(min: 0, max: self.places.count - 1)()
            // Verify that index is available on places indicies
            guard self.places.indices.contains(randomIndex) else {
                // Return out of funtion
                return
            }
            // Retrieve random place coorindate
            let placeCoordinate = self.places[randomIndex]
            // Start Rotating MapView Camera for place coordinate
            self.onChangePlace(placeCoordinate)
        }
        
        /// Get a random Index from an given array without repeating an index
        ///
        /// - Parameters:
        ///   - min: min. value
        ///   - max: max. value
        /// - Returns: random integer (without a repeating random int)
        private func randomSequenceGenerator(min: Int, max: Int) -> () -> Int {
            return {
                if self.randomNumbers.isEmpty {
                    self.randomNumbers = Array(min...max)
                }
                let index = Int(arc4random_uniform(UInt32(self.randomNumbers.count)))
                return self.randomNumbers.remove(at: index)
            }
        }
        
    }
    
}
