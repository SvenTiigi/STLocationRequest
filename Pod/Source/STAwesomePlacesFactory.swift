//
//  STLandmarksLocationFactory.swift
//  Pods
//
//  Created by Sven Tiigi on 05.09.16.
//
//

import Foundation
import CoreLocation

/// STAwesomePlacesFactory generates Coordinates from awesome Places
class STAwesomePlacesFactory {
    
    /**
     Return an array of CLLocationCoordiante2D with awesome places which will be shown on the STLocationRequestController
    */
    static func getAwesomePlaces() -> [CLLocationCoordinate2D]{
        var places: [CLLocationCoordinate2D] = []
        let parisEiffelTower = CLLocationCoordinate2DMake(48.85815,2.29452);
        let newYorkStatueOfLiberty = CLLocationCoordinate2DMake(40.689249, -74.044500);
        let sFGoldenGateBridge = CLLocationCoordinate2DMake(37.826040, -122.479448);
        let berlinBrandenburgerGate = CLLocationCoordinate2DMake(52.516275, 13.377704);
        let hamburgTownHall = CLLocationCoordinate2DMake(53.550416, 9.992527);
        let newYork = CLLocationCoordinate2DMake(40.702749, -74.014120);
        let cologneCathedral = CLLocationCoordinate2DMake(50.941278, 6.958281);
        let romeColosseum = CLLocationCoordinate2DMake(41.89021, 12.492231);
        let munichCurch = CLLocationCoordinate2DMake(48.138631, 11.573625);
        let neuschwansteinCastle = CLLocationCoordinate2DMake(47.557574, 10.749800);
        let londonBigBen = CLLocationCoordinate2DMake(51.500729, -0.124625);
        let londonEye = CLLocationCoordinate2DMake(51.503324, -0.119543);
        let sydneyOperaHouse = CLLocationCoordinate2DMake(-33.857197, 151.215140);
        let sagradaFamiliaSpain = CLLocationCoordinate2DMake(41.404024, 2.174370)
        let hamburgElbPhilharmonic = CLLocationCoordinate2DMake(53.541227, 9.984075)
        let griffithObservatory = CLLocationCoordinate2DMake(34.118536, -118.300446)
        let miamiBeach = CLLocationCoordinate2DMake(25.791007, -80.148082)
        let centralParkNY = CLLocationCoordinate2DMake(40.779269, -73.963201)
        let googlePlex = CLLocationCoordinate2DMake(37.422001, -122.084109)
        let lagunaBeach = CLLocationCoordinate2DMake(33.543361, -117.792315)
        let leMontSaintMichel = CLLocationCoordinate2DMake(48.636063, -1.511457)
        places.append(parisEiffelTower)
        places.append(newYorkStatueOfLiberty)
        places.append(sFGoldenGateBridge)
        places.append(berlinBrandenburgerGate)
        places.append(hamburgTownHall)
        places.append(newYork)
        places.append(cologneCathedral)
        places.append(romeColosseum)
        places.append(munichCurch)
        places.append(neuschwansteinCastle)
        places.append(londonBigBen)
        places.append(londonEye)
        places.append(sydneyOperaHouse)
        places.append(sagradaFamiliaSpain)
        places.append(hamburgElbPhilharmonic)
        places.append(griffithObservatory)
        places.append(miamiBeach)
        places.append(centralParkNY)
        places.append(googlePlex)
        places.append(lagunaBeach)
        places.append(leMontSaintMichel)
        return places
    }
    
}