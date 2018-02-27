//
//  ViewController.swift
//  STLocationRequest_Example
//
//  Created by Sven Tiigi on 02.12.15.
//

import CoreLocation
import UIKit
import SafariServices
import SnapKit

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
        // Layout subviews
        self.layoutSubviews()
    }
    
    func layoutSubviews() {
        // Check if running on simulator
        if self.isSimulator {
            // Layout simulator warning label
            self.simulatorWarningLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.view).offset(10)
                make.right.equalTo(self.view).inset(10)
                make.height.equalTo(60)
                make.bottom.equalTo(self.view).inset(50)
            }
        }
        // Layout PresentControllerButton
        self.presentControllerButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).inset(20)
            make.height.equalTo(60)
            if self.isSimulator {
                make.bottom.equalTo(self.simulatorWarningLabel.snp.top).offset(-20)
            } else {
                make.bottom.equalTo(self.view).inset(70)
            }
        }
        // Layout ImageView
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(120)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).inset(20)
            make.bottom.equalTo(self.presentControllerButton.snp.top).offset(-10)
        }
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
