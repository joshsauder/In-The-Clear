//
//  GMSAutocompleteViewController.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/16/18.
//  Copyright © 2018 Josh Sauder. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit
import GooglePlaces

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
        
        if(locationSelected == .startLocation){
            //replace text in box
            startLocation.text = "\(place.name)"
            locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: "Location Start", latitude: place.coordinate.longitude, longitude: place.coordinate.longitude)
        } else{
            destinationLocation.text = "\(place.name)"
            locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            createMarker(titleMarker: "Location End", latitude: place.coordinate.longitude, longitude: place.coordinate.longitude)
        }
        
        self.mapView.camera = camera
        
        if locationStart.coordinate.longitude != 0 && locationEnd.coordinate.longitude != 0 {
            showDirection()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
