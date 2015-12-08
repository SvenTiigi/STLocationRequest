# STLocationRequest

[![Version](https://img.shields.io/cocoapods/v/STLocationRequest.svg?style=flat)](http://cocoapods.org/pods/STLocationRequest)
[![License](https://img.shields.io/cocoapods/l/STLocationRequest.svg?style=flat)](http://cocoapods.org/pods/STLocationRequest)
[![Platform](https://img.shields.io/cocoapods/p/STLocationRequest.svg?style=flat)](http://cocoapods.org/pods/STLocationRequest)

STLocationRequest is a UIViewController Extension which is used to request the user location at the very first time written in Swift.


<p align="center">
<img src="./Preview/STLocationRequest.gif" alt="STLocationRequest" title="STLocationRequest">

</p>

## Usage

To show the STLocationRequestController simply call  

```swift
import STLocationRequest

self.showLocationRequestController(setTitle: "We need your location for some awesome features", setAllowButtonTitle: "Alright", setNotNowButtonTitle: "Not now", setMapViewAlphaValue: 0.7, setBackgroundViewColor: UIColor.lightGrayColor())

```

To match with your design of your app, simply playaround with the parameters _setMapViewAlphaValue_ and _setBackgroundViewColor_ to get your very own design.

Also you can add NSNotificationObserver to get notified what the user tapped

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestNotNow", name: "locationRequestNotNow", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestAuthorized", name: "locationRequestAuthorized", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationRequestDenied", name: "locationRequestDenied", object: nil)
}

func locationRequestNotNow(){
    print("The user cancled the locationRequestScreen")
}

func locationRequestAuthorized(){
    print("Location service is allowed by the user. You have now access to the user location")
}

func locationRequestDenied(){
    print("Location service are denied by the user")
}

```

For more details check out the example application


## Installation

STLocationRequest is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "STLocationRequest"
```

## Author

Sven Tiigi

## License

STLocationRequest is available under the MIT license. See the LICENSE file for more info.
