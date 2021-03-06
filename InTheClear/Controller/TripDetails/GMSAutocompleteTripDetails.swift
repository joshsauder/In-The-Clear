//
//  GMSAutocompleteTripDetails.swift
//  InTheClear
//
//  Created by Josh Sauder on 7/27/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit
import GooglePlaces

extension CustomizeTripDetails: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //add city to cities array
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let index = self.tripDetails.cityLocations.count - 1
        let indexPath = IndexPath(row: index, section: 0)
        tripDetails.addCity(city: place.name!, loc: location, index: index)
        self.dismiss(animated: true, completion: nil)
        insertCityToTable(index: indexPath)
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
