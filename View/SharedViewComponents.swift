//
//  SharedViewComponents.swift
//  InTheClear
//
//  Created by Josh Sauder on 3/14/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit


protocol SharedViewComponents {
    func showAlert(title: String, message: String) -> UIAlertController
    func showSpinner(view: UIView) -> UIView
    func stopSpinner(spinner: UIView?)
}

extension SharedViewComponents {
    
    /**
     Displays a UIAlert
     - parameters:
        - title: title of alert
        - message: the message of alert
    */
    internal func showAlert(title: String, message: String) -> UIAlertController {
        //display alert based on tyle
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    /**
     Displays a spinner while a process is executing
     - parameters:
        - view: The view in which the spinner will appear in
     - returns: a spinner UIView
     */
    internal func showSpinner(view: UIView) -> UIView {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIV = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIV.startAnimating()
        activityIV.center = view.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIV)
            view.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    /**
     Removes the spinner from the superview
     - returns: a nil UIVIew
    */
    internal func stopSpinner(spinner: UIView?) {
        DispatchQueue.main.async {
            spinner?.removeFromSuperview()
        }
    }
}

//added shared functions to each other classes
extension ViewController: SharedViewComponents {}
extension LoginController: SharedViewComponents {}
extension CustomizeTripDetails: SharedViewComponents {}
