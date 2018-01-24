//
//  RotatingMapCamera.swift
//  STLocationRequest
//
//  Created by Sven Tiigi on 23.01.18.
//

import MapKit

/// The Rotating Camera
class RotatingMapCamera {
    
    /// The MapView
    private weak var mapView: MKMapView?
    
    /// The MapView Camera
    lazy private var mapCamera: MKMapCamera = {
        let camera = MKMapCamera()
        camera.altitude = self.altitude
        camera.pitch = self.pitch
        camera.heading = 0
        return camera
    }()
    
    /// The rotation duration
    var duration: Double
    
    /// The altitude
    var altitude: CLLocationDistance {
        didSet {
            // Set MapCamera altitude
            self.mapCamera.altitude = self.altitude
            // Unwrap coordinate
            guard let coordinate = self.coordinate else {
                // No coordinate available
                return
            }
            // Reset MapView Region for new altitude
            self.mapView?.region = MKCoordinateRegionMakeWithDistance(
                coordinate,
                self.altitude,
                self.altitude
            )
        }
    }
    
    /// The pitch
    var pitch: CGFloat {
        didSet {
            // Set MapCamera pitch
            self.mapCamera.pitch = self.pitch
        }
    }
    
    /// The headingStep
    var headingStep: Double
    
    /// Is currently rotating
    var isRotating: Bool {
        return self.coordinate != nil
    }
    
    /// The current coordinate
    private var coordinate: CLLocationCoordinate2D?
    
    /// Default Initializer
    ///
    /// - Parameters:
    ///   - mapView: The MapView reference
    ///   - duration: The rotation duration. Default value: 4.0
    ///   - altitude: The altitude. Default value: 600.0
    ///   - pitch: The pitch. Default value: 45.0
    ///   - headingStep: The headingStep. Default value: 20.0
    init(mapView: MKMapView,
                duration: Double = 4.0,
                altitude: CLLocationDistance = 600.0,
                pitch: CGFloat = 45.0,
                headingStep: Double = 20.0) {
        self.mapView = mapView
        self.duration = duration
        self.altitude = altitude
        self.pitch = pitch
        self.headingStep = headingStep
    }
    
    /// Start rotation with corrdinate
    ///
    /// - Parameter coordinate: The coordinate
    func start(lookingAt coordinate: CLLocationCoordinate2D, animated: Bool = true) {
        // Set coordinate
        self.coordinate = coordinate
        // Set mapView region for place coordinate
        UIView.animate(withDuration: animated ? 2.0 : 0.0) {
            self.mapView?.region = MKCoordinateRegionMakeWithDistance(
                coordinate,
                self.altitude,
                self.altitude
            )
            // Set center coordinate for mapCamera by setting place coordinate
            self.mapCamera.centerCoordinate = coordinate
            // Set mapView camera
            self.mapView?.setCamera(self.mapCamera, animated: false)
        }
        // Invoke mapView rotation
        self.rotate(coordinate)
    }
    
    /// Stop rotation
    func stop() {
        // Clear coordinate
        self.coordinate = nil
    }
    
    /// Rotate MapViewCamera
    private func rotate(_ coordinate: CLLocationCoordinate2D) {
        // Increase heading by heading step for mapCamera
        self.mapCamera.heading = fmod(self.mapCamera.heading + self.headingStep, 360)
        // Animate MapView camera change
        UIView.animate(withDuration: self.duration,
                       delay: 0,
                       options: [.curveLinear, .curveEaseOut, .beginFromCurrentState],
                       animations: {
                        // Set mapView camera
                        self.mapView?.camera = self.mapCamera
        }) { (finished: Bool) in
            // Recursive invocation after completion
            if finished
                && self.coordinate?.latitude == coordinate.latitude
                && self.coordinate?.longitude == coordinate.longitude {
                self.rotate(coordinate)
            }
        }
    }
    
}
