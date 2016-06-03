//
//  STLocationRequest.swift
//  Pods
//
//  Created by Sven Tiigi on 03.06.16.
//
//

import UIKit

@objc public class STLocationRequest: NSObject {
    
    public var titleText = String()
    public var allowButtonTitle = String()
    public var notNowButtonTitle = String()
    public var mapViewAlphaValue = CGFloat()
    public var backgroundViewColor : UIColor?
    public var delegate : LocationRequestDelegate?
    public var viewController : UIViewController?
    
    public init(viewController : UIViewController){
        self.viewController = viewController;
        super.init()
    }
    
    public func presentLocationRequestController(){
        
        // Check if viewcontroller is not nil
        guard let viewController = self.viewController else{
            print("STLocationRequestController couldn't be presented cause there is no parent UIViewController")
            return
        }
        
        // Create the Bundle Path for Resources
        let bundlePath = NSBundle(forClass: STLocationRequestController.self).pathForResource("STLocationRequest", ofType: "bundle")
        
        // Get the Storyboard File
        let stb = UIStoryboard(name: "StoryboardLocationRequest", bundle:NSBundle(path: bundlePath!))
        
        // Instantiate the ViewController by Identifer as STLocationRequestController
        let locationRequestViewController = stb.instantiateViewControllerWithIdentifier("locationRequestController") as! STLocationRequestController
        
        locationRequestViewController.titleLabelText = self.titleText
        locationRequestViewController.allowButtonTitle = self.allowButtonTitle
        locationRequestViewController.notNowButtonTitle = self.notNowButtonTitle
        locationRequestViewController.mapViewAlphaValue = self.mapViewAlphaValue
        locationRequestViewController.backgroundViewColor = self.backgroundViewColor
        locationRequestViewController.delegate = self.delegate
        
        // Present the locationRequestViewController
        viewController.presentViewController(locationRequestViewController, animated: true) {
            self.delegate?.locationRequestControllerPresented()
        }
    }
    
    
}
