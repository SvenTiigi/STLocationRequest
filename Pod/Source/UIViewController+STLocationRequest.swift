//
//  UIViewController+STLocationRequest.swift
//  Pods
//
//  Created by Sven Tiigi on 02.12.15.
//
//

import Foundation
import UIKit

extension UIViewController {
    /*
        UIViewController extension for showing the LocationRequestScreen
    */
    public func showLocationRequestController(setTitle title: String,setAllowButtonTitle allowButtonTitle : String,setNotNowButtonTitle notNowButtonTitle : String,setMapViewAlphaValue mapViewAlphaValue:CGFloat,setBackgroundViewColor backgroundViewColor: UIColor){
        // Create a Bundle
        let frameworkBundle = NSBundle(identifier: "org.cocoapods.STLocationRequest")
        // Get the Storyboard File
        let stb = UIStoryboard(name: "StoryboardLocationRequest", bundle:frameworkBundle)
        // Instantiate the ViewController by Identifer as STLocationRequestController
        let locationRequestViewController = stb.instantiateViewControllerWithIdentifier("locationRequestController") as! STLocationRequestController
        // Passing the parameters Values
        locationRequestViewController.titleLabelText = title
        locationRequestViewController.allowButtonTitle = allowButtonTitle
        locationRequestViewController.notNowButtonTitle = notNowButtonTitle
        locationRequestViewController.mapViewAlphaValue = mapViewAlphaValue
        locationRequestViewController.backgroundViewColor = backgroundViewColor
        // Present the locationRequestViewController
        self.presentViewController(locationRequestViewController, animated: true, completion: nil)
    }
    
    
}