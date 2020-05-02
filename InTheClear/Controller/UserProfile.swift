//
//  UserProfile.swift
//  InTheClear
//
//  Created by Josh Sauder on 4/29/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserProfile: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var UserInfoTable: UITableView!
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    let details = ["Name", "Email", "Date Joined", "Total Trips", "Favorite Destination"]
    var userDetails: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUserDetails()
        setupLogoutButton(button: LogoutButton)
        setupTable(tableView: UserInfoTable)
        UserInfoTable.allowsSelection = false;
        
        UserInfoTable.delegate = self
        UserInfoTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")
        
        //text label is on left side, details text label is on right side
        cell.textLabel?.text = details[indexPath.row]
        cell.detailTextLabel?.text = userDetails[details[indexPath.row]]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setupHeader(title: "Profile", width: tableView.frame.width)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //dynamic tableview height
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    
    /**
     Sets up the user details to be shown in UITableView
     */
    func setupUserDetails(){
        let manager = RealmManager()
        let user = manager.getUser()
        let trips = manager.getTripHistory()
        
        let df = DateFormatter()
        df.dateStyle = .medium
        
        userDetails = [details[1] : user.email,
            details[2] : df.string(from: user.dateJoined),
            details[3] : String(trips.count),
            details[4] : determineMostUsed(trips: trips),
            details[0] : user.name
            ]
    }
    
    /**
     Handles logout button onTap action
     - parameters:
        - sender:the button tapped
     */
    @IBAction func LogoutButtonTapped(_ sender: Any) {
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
            showLoginView()
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    
    /**
     Presents the login view when you logout
     */
    func showLoginView(){
        let vc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() as! LoginController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    /**
     Determines the most searched for destination
     - parameters:
        - trips: List of trips
     - returns: the most search for trip
     */
    func determineMostUsed(trips: [TripData]) -> String{
        var counts : [String: Int] = [:]
        trips.forEach{ counts[$0.locations.last!.city] = (counts[$0.locations.last!.city] ?? 0) + 1}
    
        //similar to javascript array sort
        let max = counts.max {a, b in a.value < b.value}
        return max?.key ?? ""
    }
    
}
