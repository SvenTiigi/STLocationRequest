//
//  AppDelegate.swift
//  Example-iOS
//
//  Created by Sven Tiigi on 18.01.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// The Window
    var window: UIWindow?
    
    /// The UINavigationController with ViewController as rootViewController
    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: ViewController())
        if #available(iOS 11.0, *) {
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.largeTitleTextAttributes = [
                .foregroundColor: UIColor.main
            ]
        }
        navigationController.navigationBar.tintColor = .main
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.main]
        return navigationController
    }()
    
    /// Application did finish launching with options
    ///
    /// - Parameters:
    ///   - application: The Application
    ///   - launchOptions: The LaunchOptions
    /// - Returns: Bool
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()
        return true
    }

}

