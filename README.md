# STLocationRequest

[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Version](https://img.shields.io/cocoapods/v/STLocationRequest.svg?style=flat)](http://cocoapods.org/pods/STLocationRequest)
[![License](https://img.shields.io/cocoapods/l/STLocationRequest.svg?style=flat)](http://cocoapods.org/pods/STLocationRequest)
[![Platform](https://img.shields.io/cocoapods/p/STLocationRequest.svg?style=flat)](http://cocoapods.org/pods/STLocationRequest)
[![Downloads](https://img.shields.io/cocoapods/dt/STLocationRequest.svg?style=flat)](http://cocoapods.org/pods/STLocationRequest)
[![Twitter](https://img.shields.io/badge/Twitter-@SvenTiigi-blue.svg?style=flat)](https://twitter.com/SvenTiigi/)

<img style="float: right" src="https://raw.githubusercontent.com/SvenTiigi/STLocationRequest/master/.assets/STLocationRequest.gif" alt="Demo GIF" align="right" width="60%" />
<br/>

## Description
STLocationRequest is a simple and elegant way to request the users location services at the very first time written in Swift. The `STLocationRequestController` shows a beautiful 3D 360° Flyover MapView with over 25 cities and landmarks 🗺.

<br/><br/>

## Installation

STLocationRequest is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'STLocationRequest', '~> 3.0'
```

## Usage

```swift
import STLocationRequest

// Initialize STLocationRequestController with STLocationRequestController.Configuration
let locationRequestController = STLocationRequestController { config in
    config.titleText = "We need your location for some awesome features"
    config.allowButtonTitle = "Alright"
    config.notNowButtonTitle = "Not now"
    config.mapViewAlpha = 0.9
    config.backgroundColor = UIColor.lightGray
    config.authorizeType = .requestWhenInUseAuthorization
}

// Get notified on STLocationRequestController.Events
locationRequestController.onEvent = { event in
    if case .locationRequestAuthorized = event {
        // Location Request Authorized 🙌
    }
}

// Present STLocationRequestController
locationRequestController.present(onViewController: self)
```
> Please keep in mind that the 3D SatelliteFlyover only works on a real iOS Device ([Read more](#ios-simulator)).

## Configuration
The `STLocationRequestController` can be customized via the the `STLocationRequestController.Configuration` struct. There are plenty of options available 👨‍💻 More details can be found [here]()

## OnEvent
The `onEvent` closure allows you to get notified if an `STLocationRequestController.Event` occured. For example to detect if the user has authorized or denied the location request or tapped the `Not Now` Button.

```swift
locationRequestController.onEvent = { (event: STLocationRequestController.Event) in
    switch event {
        case .locationRequestAuthorized:
            break
        case .locationRequestDenied:
            break
        case .notNowButtonTapped:
            break
        case .didPresented:
            break
        case .didDisappear:
            break
    }
}
```

Or just simply pass a function 👌

```swift
locationRequestController.onEvent = onLocationRequestControllerEvent

func onLocationRequestControllerEvent(_ event: STLocationRequestController.Event) {
    // Evaluate the event
}
```

## Info.plist

In order to perform a location request you have to define a usage description in your `Info.plist` file.

STLocationRequestController.Authorization.**requestWhenInUseAuthorization**
```swift
<key>NSLocationWhenInUseUsageDescription</key>
<string>The usage description</string>
```

STLocationRequestController.Authorization.**requestAlwaysAuthorization**
```swift
<key>NSLocationAlwaysUsageDescription</key>
<string>The usage description</string>
```

This text will be shown in the default iOS location request dialog, which will show up when the user tapped the allow button.

<p align="center">
<img src="https://raw.githubusercontent.com/SvenTiigi/STLocationRequest/master/.assets/iOSLocationRequestDialog.png" alt="iOSRequestDialog" title="iOSRequestDialog" width=300>

</p>

## Presenting-Recommendation

The recommended way to present `STLocationRequestController` is the following way.

```swift
if STLocationRequestController.shouldPresentLocationRequestController {
    // Location Services are enabled and authorizationStatus is notDetermined
    // Ready to present STLocationRequestController
    self.presentLocationRequestController()
}
```

## iOS Simulator

Please keep in mind that the 3D flyover view will only work on a real iOS device with at least iOS 9.0 installed ([Apple Developer API Reference](https://developer.apple.com/reference/mapkit/mkmaptype/1452553-satelliteflyover)). A Screenshot taken from an **iOS Simulator** running a `STLocationRequestController` visualizes the iOS Simulator behaviour.

<p align="center">
<img src="https://raw.githubusercontent.com/SvenTiigi/STLocationRequest/master/.assets/iOSSimulatorBehavior.jpg" alt="iOSSimulatorBehavior" title="iOSSimulatorBehavior" width=300>
</p>

## Dependencies
`STLocationRequest` is using following libraries.

+ [Font-Awesome-Swift](https://github.com/Vaberer/Font-Awesome-Swift)
+ [SwiftPulse](https://github.com/ctews/SwiftPulse)
+ [SnapKit](https://github.com/SnapKit/SnapKit)

# Contributing
Contributions are very welcome 🙌 🤓

## License

```
STLocationRequest
Copyright (c) 2018 Sven Tiigi <sven.tiigi@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
