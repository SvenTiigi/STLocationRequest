<p align="center">
    <img src="https://raw.githubusercontent.com/SvenTiigi/STLocationRequest/gh-pages/readMeAssets/STLocationRequest_Logo.png" alt="Logo" width="30%">
</p>
<br/>

<h1 align="center">STLocationRequest</h1>
<p align="center">
    <a href="https://developer.apple.com/swift/">
        <img src="https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat" alt="Swift 4.0">
    </a>
    <a href="https://travis-ci.org/SvenTiigi/STLocationRequest">
        <img src="https://travis-ci.org/SvenTiigi/STLocationRequest.svg?branch=master" alt="Build Status">
    </a>
    <a href="http://cocoapods.org/pods/STLocationRequest">
        <img src="https://img.shields.io/cocoapods/v/STLocationRequest.svg?style=flat" alt="Version">
    </a>
    <a href="https://github.com/Carthage/Carthage">
        <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage Compatible">
    </a>
    <a href="http://cocoapods.org/pods/STLocationRequest">
        <img src="https://img.shields.io/cocoapods/p/STLocationRequest.svg?style=flat" alt="Platform">
    </a>
    <a href="http://cocoapods.org/pods/STLocationRequest">
        <img src="https://img.shields.io/cocoapods/dt/STLocationRequest.svg?style=flat" alt="Downloads">
    </a>
    <br/>
    <a href="https://codeclimate.com/github/SvenTiigi/STLocationRequest/maintainability">
        <img src="https://api.codeclimate.com/v1/badges/705327ebce8601d9df4b/maintainability" alt="Maintainability">
    </a>
    <a href="https://sventiigi.github.io/STLocationRequest">
        <img src="https://github.com/SvenTiigi/STLocationRequest/blob/gh-pages/badge.svg" alt="Documentation">
    </a>
    <a href="https://twitter.com/SvenTiigi/">
        <img src="https://img.shields.io/badge/Twitter-@SvenTiigi-blue.svg?style=flat" alt="Twitter">
    </a>
</p>

STLocationRequest is a simple and elegant way to request the users location services at the very first time. The `STLocationRequestController` shows a beautiful 3D 360° Flyover-MapView bult on top of [FlyoverKit](https://github.com/SvenTiigi/FlyoverKit) with over 25 cities and landmarks.

<p align="center">
    <img src="https://raw.githubusercontent.com/SvenTiigi/STLocationRequest/gh-pages/readMeAssets/STLocationRequest.gif" alt="Preview GIF" width="70%">
</p>

## Installation

### CocoaPods

STLocationRequest is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```bash
pod 'STLocationRequest'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate STLocationRequest into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "SvenTiigi/STLocationRequest"
```

Run `carthage update --platform iOS` to build the framework and drag the built

* `STLocationRequest.framework`
* `FlyoverKit.framework`
* `SnapKit.framework`
* `SwiftIconFont.framwork`

into your Xcode project. 

On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase” and add the Framework paths (for all Frameworks) as mentioned in [Carthage Getting started Step 4, 5 and 6](https://github.com/Carthage/Carthage/blob/master/README.md)

## Usage

```swift
import STLocationRequest

// Initialize STLocationRequestController with STLocationRequestController.Configuration
let locationRequestController = STLocationRequestController { (config: inout STLocationRequestController.Configuration) in
    config.title.text = "We need your location for some awesome features"
    config.allowButton.title = "Alright"
    config.notNowButton.title = "Not now"
    config.mapView.alpha = 0.9
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
> Please keep in mind that the 3D flyover view will only work on a real iOS device ([Read more](#ios-simulator)).

## Configuration
The `STLocationRequestController` can be customized via the the `STLocationRequestController.Configuration` struct. There are plenty of options available 👨‍💻 More details can be found [here](https://github.com/SvenTiigi/STLocationRequest/blob/master/STLocationRequest/Configuration/STLocationRequestController%2BConfiguration.swift)

## OnEvent
The `onEvent` function get invoked if an `STLocationRequestController.Event` occured. Simply set an anonymous function of type `(Event) -> Void` to evaluate the event.

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

or just pass a function 👌

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

The usage description will be shown in the default iOS location request dialog, which will show up when the user tapped the allow button.

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
<img src="https://raw.githubusercontent.com/SvenTiigi/STLocationRequest/gh-pages/readMeAssets/iOSSimulatorBehavior.jpg" alt="iOSSimulatorBehavior" title="iOSSimulatorBehavior" width=300>
</p>

## Dependencies
`STLocationRequest` is using following libraries.

+ [FlyoverKit](https://github.com/SvenTiigi/FlyoverKit)
+ [SwiftIconFont](https://github.com/0x73/SwiftIconFont)
+ [SwiftPulse](https://github.com/ctews/SwiftPulse)
+ [SnapKit](https://github.com/SnapKit/SnapKit)

## Contributing
Contributions are very welcome 🙌 🤓

## Example Application
In order to run the example Application you have to first generate the Frameworks via `Carthage`.

```bash
$ carthage update --platform iOS
$ open STLocationRequest.xcodeproj
```

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
