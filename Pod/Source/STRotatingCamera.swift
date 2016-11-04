//
//  STRotatingCamera.swift
//  Pods
//
//  Created by Sven Tiigi on 03.12.15.
//
// Swift clone of: https://github.com/fernandospr/FSRotatingCamera

import UIKit
import MapKit

class STRotatingCamera: NSObject {
	var mapView: MKMapView
	var rotating: Bool
	var headingStep: Double
	
	let DEFAULT_HEADING = 0.0
	let DEFAULT_PITCH : CGFloat = 45.0
	let DEFAULT_ALTITUDE = 700.0
	let DEFAULT_HEADING_STEP = 10.0
	
	init (mapView : MKMapView) {
		self.mapView = mapView
		self.rotating = false
		self.headingStep = 0
	}
	
	override init() {
		self.mapView = MKMapView()
		self.rotating = false
		self.headingStep = 0
	}
	
	func setMap(_ map: MKMapView) {
		self.mapView = map
	}
	
	func startRotatingWithCoordinate(_ coordinate: CLLocationCoordinate2D, heading: CLLocationDirection, pitch: CGFloat, altitude: CLLocationDistance, headingStep: Double) {
		let camera = MKMapCamera()
		camera.centerCoordinate = coordinate
		camera.heading = heading
		camera.pitch = pitch
		camera.altitude = altitude
		self.mapView.setCamera(camera, animated: true)
		self.rotating = true
		self.headingStep = headingStep
	}
	
	func startRotatingWithCoordinate(_ coordinate : CLLocationCoordinate2D) {
		self.startRotatingWithCoordinate(coordinate, heading: self.DEFAULT_HEADING, pitch: self.DEFAULT_PITCH, altitude: self.DEFAULT_ALTITUDE, headingStep: self.DEFAULT_HEADING_STEP)
	}
	
	func startRotating() {
		self.startRotatingWithCoordinate(self.mapView.centerCoordinate)
	}
	
	func stopRotating() {
		self.rotating = false
	}
	
	func isStopped() -> Bool {
		return self.rotating
	}
	
	func continueRotating() {
		if let camera = self.mapView.camera.copy() as? MKMapCamera {
			camera.heading = fmod(camera.heading+self.headingStep, 360)
			UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
				self.mapView.camera = camera
				}, completion: nil)
		}
	}

}
