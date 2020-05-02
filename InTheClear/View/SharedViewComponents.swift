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


protocol TableViewSetup {
    func setupHeader(title: String, width: CGFloat) -> UIView
    func setupTable(tableView: UITableView)
}

extension TableViewSetup {
    
    /**
    Sets up a standardized UIView to be used as UITableView Header
     - parameters:
        - title: Header title
        - width: width of UITableView
     - returns: UIView to be used as header
     */
    internal func setupHeader(title: String, width: CGFloat) -> UIView {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: 100))
        headerView.backgroundColor = UIColor(red: 0.52, green: 0.11, blue: 0.52, alpha: 1.00)

        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 55, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = title
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        headerView.addSubview(label)

        return headerView
    }
    
    /**
     Setups up a UITableView
     - parameters:
        - tableView: UITableView to setup
     */
    internal func setupTable(tableView: UITableView){
        //full width separator
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        
        //notch support
        tableView.insetsContentViewsToSafeArea = false;
        tableView.contentInsetAdjustmentBehavior = .never;
        
        tableView.backgroundColor = UIColor(red: 0.52, green: 0.11, blue: 0.52, alpha: 1.00)
    }
}

//added shared functions to each other classes
extension UserProfile: TableViewSetup {}
extension TripHistoryController: TableViewSetup {}
