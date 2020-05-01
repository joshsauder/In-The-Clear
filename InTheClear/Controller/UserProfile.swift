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

class UserProfile: UIViewController {
    @IBOutlet weak var UserInfoTable: UITableView!
    @IBOutlet weak var LougoutButton: UIButton!
    
    var userDetails: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserDetails()
    }
    
    
    func setupTable(){
        
    }
    
    
    
    func setupUserDetails(){
        let manager = RealmManager()
        let user = manager.getUser()
        let trips = manager.getTripHistory()
        
        let df = DateFormatter()
        df.dateStyle = .medium
        
        
        userDetails = ["Email" : user.email,
                       "Date Joined": df.string(from: user.dateJoined),
                       "Total Trips": String(trips.count),
                       "Favorite Destination": determineMostUsed(trips: trips)
                      ]
    }
    
    @IBAction func LougoutButtonTapped(_ sender: Any) {
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
            showLoginView()
        } catch let signOutError as NSError {
            print(signOutError)
        }
    }
    
    func showLoginView(){
        let vc = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController() as! LoginController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func determineMostUsed(trips: [TripData]) -> String{
        var counts : [String: Int] = [:]
        trips.forEach{ counts[$0.locations.last!.city] = (counts[$0.locations.last!.city] ?? 0) + 1}
    
        let max = counts.max {a, b in a.value < b.value}
        return max?.key ?? ""
    }
    
}
