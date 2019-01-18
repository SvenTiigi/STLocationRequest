//
//  ViewController.swift
//  Example-iOS
//
//  Created by Sven Tiigi on 18.01.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import UIKit

import CoreLocation
import UIKit
import SafariServices

/// Example application ViewController to present the STLocationRequestController
class ViewController: UIViewController {
    
    // MARK: Properties
    
    /// The present controller button
    lazy var presentControllerButton: UIButton = {
        let button = PresentButton(title: "Present STLocationRequestController")
        button.addTarget(self, action: #selector(presentControllerButtonTouched(_:)), for: .touchUpInside)
        return button
    }()
    
    /// The simulator warning label
    lazy var simulatorWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "Please keep in mind that the 3D flyover view will only work on a real iOS device ☝️"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .lightGray
        return label
    }()
    
    /// The image view
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.loadGif(name: "PreviewGIF")
        return imageView
    }()
    
    /// The CLLocationManager
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        return locationManager
    }()
    
    /// Computed Property if running on simulator
    var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    // MARK: View-Lifecycle
    
    /// View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set title
        self.title = "STLocationRequest"
        // Add NavigationItems
        self.addNavigationItems()
        // Set background color
        self.view.backgroundColor = .white
        // Add subviews
        self.view.addSubview(self.presentControllerButton)
        // Check if running on simulator
        if self.isSimulator {
            self.view.addSubview(self.simulatorWarningLabel)
        }
        self.view.addSubview(self.imageView)
        // Make Constraints
        self.makeConstraints()
    }
    
    // MARK: Constraints
    
    /// Make Constraints
    func makeConstraints() {
        // Check if running on simulator
        if self.isSimulator {
            // Layout simulator warning label
            self.simulatorWarningLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.simulatorWarningLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                self.simulatorWarningLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                self.simulatorWarningLabel.heightAnchor.constraint(equalToConstant: 60),
                self.simulatorWarningLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
            ])
        }
        // Layout PresentControllerButton
        self.presentControllerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.presentControllerButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.presentControllerButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.presentControllerButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        if self.isSimulator {
            self.presentControllerButton.bottomAnchor.constraint(equalTo: self.simulatorWarningLabel.topAnchor, constant: -20).isActive = true
        } else {
            self.presentControllerButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -70).isActive = true
        }
        // Layout ImageView
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.imageView.bottomAnchor.constraint(equalTo: self.presentControllerButton.topAnchor, constant: -10)
        ])
    }
    
    // MARK: NavigationItems
    
    /// Add NavigationItems
    func addNavigationItems() {
        let githubBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "github"),
            style: .plain,
            target: self,
            action: #selector(githubBarButtonItemTouched(_:))
        )
        self.navigationItem.rightBarButtonItem = githubBarButtonItem
    }
    
    // MARK: Button Action Target
    
    /// PresentControllerButton touched handler
    @objc func presentControllerButtonTouched(_ sender: UIButton) {
        self.presentLocationRequestController()
    }
    
    /// Github BarButtonItem touched handler
    @objc func githubBarButtonItemTouched(_ sender: UIBarButtonItem) {
        guard let url = URL(string: "https://github.com/SvenTiigi/STLocationRequest/blob/master/README.md") else {
            print("Unable to construct Github Repo URL")
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .main
        self.present(safariViewController, animated: true)
    }
    
}

// MARK: CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    /// CLLocationManagerDelegate DidFailWithError Methods
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error. The Location couldn't be found. \(error)")
    }
    
    /// CLLocationManagerDelegate didUpdateLocations Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        print("didUpdateLocations UserLocation: \(String(describing: locations.last))")
    }
    
}


