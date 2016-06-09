//
//  STLocationRequest.swift
//  Pods
//
//  Created by Sven Tiigi on 03.06.16.
//
//

import UIKit

/// STLocationRequestEvent Enum for events in the delegate Method locationRequestControllerDidChange
@objc public enum STLocationRequestEvent : Int{
    case LocationRequestAuthorized
    case LocationRequestDenied
    case NotNowButtonTapped
    case LocationRequestDidPresented
}

/// STLocationRequestType Enum for decide which location request type should be used
@objc public enum STLocationAuthorizeType : Int{
    case RequestWhenInUseAuthorization
    case RequestAlwaysAuthorization
}

/// STLocationRequest Delegate
@objc public protocol STLocationRequestDelegate{
    /**
        STLocationRequestDelegate which is used to handle events from the STLocationRequestController.
        Example usage:
        ----
            func locationRequestControllerDidChange(event: STLocationRequestEvent) {
                switch event {
                    case .LocationRequestAuthorized:
                        break
                    case .LocationRequestDenied:
                        break
                    case .NotNowButtonTapped:
                        break
                    case .LocationRequestDidPresented:
                        break
                }
            }
     */
    @objc func locationRequestControllerDidChange(event : STLocationRequestEvent)
}

/// STLocationRequest is a UIViewController-Extension which is used to request the User-Location, at the very first time, in a simple and elegent way. It shows a beautiful 3D 360 degree Flyover-MapView which shows 14 random citys or landmarks.
@objc public class STLocationRequest: NSObject {
    
    /// The title which will be presented at the top of the STLocationRequestController. Default-Value: "We need your location for some awesome features"
    public var titleText = "We need your location for some awesome features"
    /// The title for the allowButton which will trigger the requestWhenInUseAuthorization() Method on CLLocationManager. Default value is "Alright"
    public var allowButtonTitle = "Alright"
    /// The title for the notNowButton which will dismiss the STLocationRequestController. Default value is "Not now"
    public var notNowButtonTitle = "Not now"
    /// The alpha value for the MapView which is used in combination with `backgroundViewColor` to match the STLocationRequestController with the design of your app. Default value is 1
    public var mapViewAlphaValue : CGFloat?
    /// The backgroundcolor for the view of the STLocationRequestController which is used in combination with `mapViewAlphaValue` to match the STLocationRequestController with the design of your app. Default value is a white color.
    public var backgroundColor : UIColor?
    
    /// Set the authorize Type for STLocationRequestController. Choose between: `RequestWhenInUseAuthorization` and `RequestAlwaysAuthorization`. Default value is `RequestWhenInUseAuthorization`
    public var authorizeType : STLocationAuthorizeType?
    
    /// STLocationRequestDelegate which is used to handle events from the STLocationRequestController.
    public var delegate : STLocationRequestDelegate?
    
    /**
     Present the STLocationRequestController modally on a given UIViewController
     
     iOS Simulator:
     ----
     Please mind that the 3D Flyover-View will only work on a **real** iOS Device **not** in the Simulator with at least iOS 9.0 installed
     
     Example usage:
     ----
           let locationRequest = STLocationRequest()
           locationRequest.titleText = "We need your location for some awesome features"
           locationRequest.allowButtonTitle = "Alright"
           locationRequest.notNowButtonTitle = "Not now"
           locationRequest.mapViewAlphaValue = 0.9
           locationRequest.backgroundViewColor = UIColor.lightGrayColor()
           locationRequest.delegate = self
           locationRequest.authorizeType = .RequestWhenInUseAuthorization
           locationRequest.presentLocationRequestController(onViewController: self)
     
     More Information
     --------------
     
     More information can be found in the ReadMe file [Github](https://github.com/SvenTiigi/STLocationRequest/blob/master/README.md)
    
     - parameters:
        - viewController: The `UIViewController` which will be used to present the STLocationRequestController modally.
     */
    public func presentLocationRequestController(onViewController viewController : UIViewController){
        // Create the Bundle Path for Resources
        let bundlePath = NSBundle(forClass: STLocationRequestController.self).pathForResource("STLocationRequest", ofType: "bundle")
        
        // Get the Storyboard File
        let stb = UIStoryboard(name: "StoryboardLocationRequest", bundle:NSBundle(path: bundlePath!))
        
        // Instantiate the ViewController by Identifer as STLocationRequestController
        let locationRequestViewController = stb.instantiateViewControllerWithIdentifier("locationRequestController") as! STLocationRequestController
        
        // Set the properties on STLocationRequestController
        locationRequestViewController.titleLabelText = self.titleText
        locationRequestViewController.allowButtonTitle = self.allowButtonTitle
        locationRequestViewController.notNowButtonTitle = self.notNowButtonTitle
        locationRequestViewController.mapViewAlphaValue = self.mapViewAlphaValue
        locationRequestViewController.backgroundViewColor = self.backgroundColor
        locationRequestViewController.authorizeType = self.authorizeType
        locationRequestViewController.delegate = self.delegate
        
        // Present the locationRequestViewController on passed UIViewController
        viewController.presentViewController(locationRequestViewController, animated: true) {
            self.delegate?.locationRequestControllerDidChange(.LocationRequestDidPresented)
        }
    }
    
}
