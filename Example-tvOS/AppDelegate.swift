//
//  AppDelegate.swift
//  Example-tvOS
//
//  Created by Sven Tiigi on 18.01.19.
//  Copyright © 2019 Sven Tiigi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// The Window
    var window: UIWindow?
    
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
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
        return true
    }

}

