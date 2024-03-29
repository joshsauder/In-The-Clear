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
    
    @IBOutlet weak var PremiumView: UIView!
    @IBOutlet weak var UserInfoTable: UITableView!
    @IBOutlet weak var UserActionsTable: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var PayLabel: UILabel!
    @IBOutlet weak var FirstPremiumBenefitLabel: UILabel!
    @IBOutlet weak var SecondPremiumBenefitLabel: UILabel!
    @IBOutlet weak var LegalTextView: UITextView!
    @IBOutlet weak var ProfileToPremiumConstraint: NSLayoutConstraint!
    
    let storeKitHandler = StoreKitHandler()
    let realmManager = RealmManager()
    let firestoreManager = FirestoreManager()
    
    let details = ["Name", "Email", "Total Trips", "Favorite Destination", "Paid"]
    var UserActions = ["Upgrade to Premium", "Restore Purchase", "Logout"]
    var userDetails: [String:String] = [:]
    var user: UserData = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUserDetails()
        premiumLabelSetup()
        premiumViewSetup()
        setupTable(tableView: UserInfoTable)
        
        if(userDetails[details[4]] == "true"){
            UserActions.removeFirst()
        }
        
        // Setup UI Table Views
        UserInfoTable.allowsSelection = false
        UserActionsTable.allowsSelection = true
        UserInfoTable.delegate = self
        UserInfoTable.dataSource = self
        UserActionsTable.delegate = self
        UserActionsTable.dataSource = self
        UserInfoTable.isScrollEnabled = false

        // Fix table insets
        UserActionsTable.layoutMargins = UIEdgeInsets.zero
        UserActionsTable.separatorInset = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == UserActionsTable {
            return UserActions.count
        }
        return details.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cellId")
        
        if tableView == UserActionsTable {
            cell.textLabel?.text = UserActions[indexPath.row]
            // style cell
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
        } else {
            //text label is on left side, details text label is on right side
            cell.textLabel?.text = details[indexPath.row]
            cell.detailTextLabel?.text = userDetails[details[indexPath.row]]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIScreen.main.bounds.height < 700 {
            if tableView == UserActionsTable {
                return 15
            }
            return 50
        }
        if tableView == UserActionsTable {
            return 30
        }
        return 130
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == UserActionsTable {
            return nil
        }
        return setupHeader(title: "Profile", width: tableView.frame.width)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        if tableView == UserActionsTable {
            return "  Profile Actions"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //dynamic tableview height
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == UserActionsTable {
            if indexPath.row == 0 && userDetails[details[4]] != "true" {
                UpgradeButtonTapped()
            } else if indexPath.row == 0 && userDetails[details[4]] == "true" {
                RestorePurchaseButtonTapped()
            } else if indexPath.row == 1 && userDetails[details[4]] != "true" {
                RestorePurchaseButtonTapped()
            } else {
                LogoutButtonTapped()
            }
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    
    /**
     Sets up the user details to be shown in UITableView
     */
    func setupUserDetails(){
        user = realmManager.getUser()
        
        let trips = realmManager.getTripHistory()
        
        let df = DateFormatter()
        df.dateStyle = .medium
        
        userDetails = [details[1] : user.email,
            details[2] : String(trips.count),
            details[3] : determineMostUsed(trips: trips),
            details[0] : user.name,
            details[4] : user.paid.description
            ]
    }
    
    /**
     Handles logout button onTap action
     */
    func LogoutButtonTapped() {
        let auth = Auth.auth()
        
        do {
            try auth.signOut()
            showLoginView()
        } catch let signOutError as NSError {
            self.present(self.showAlert(title: "Issue Signing Out", message: "There was an issue signing you out. Please try again."), animated: true)
        }
    }
    
    /**
     Handles the upgrade button being tapped
     */
    func UpgradeButtonTapped() {
        user = realmManager.getUser()
        storeKitHandler.purchase(product: storeKitHandler.YEARLY)
        storeKitHandler.productDidPurchased = {
            [weak self] (date: Date?) in
            self?.firestoreManager.updatePaid(userId: (self?.user.id)!, date: date)
            self?.realmManager.updatePaid(user: (self?.user)!)
            
            // Remove upgrade logo
            self?.UserActions.removeFirst()
            self?.UserActionsTable.beginUpdates()
            self?.UserActionsTable.deleteRows(at: [IndexPath.init(row: 0, section: 0)], with: UITableView.RowAnimation.right)
            self?.UserActionsTable.endUpdates()
            
            self?.userDetails[(self?.details[4])!] = "true"
            // Update Premium Label
            self?.updateLabel()
        
        }
    }
    
    /**
     Handles the restore purchase button being tapped
     */
    func RestorePurchaseButtonTapped(){
        storeKitHandler.restorePreviousPurchase()
    }
    
    /**
     Presents the login view when you logout
     */
    func showLoginView(){
        let vc = UIStoryboard(name: "StartView", bundle: nil).instantiateInitialViewController() as! LoginController
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
