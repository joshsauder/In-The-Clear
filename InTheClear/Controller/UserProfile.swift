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
    
}
