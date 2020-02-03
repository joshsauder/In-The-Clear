//
//  RegisterViewController.swift
//  InTheClear
//
//  Created by Josh Sauder on 2/2/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController : UIViewController {
    
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var FirstNameText: UITextField!
    @IBOutlet weak var LastNameText: UITextField!
    @IBOutlet weak var SubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func RegisterSubmit(_ sender: Any) {
        
        var userDetails = [String:String]()
        userDetails["Email"] = EmailText!.text
        userDetails["Password"] = PasswordText!.text
        userDetails["FirstName"] = FirstNameText!.text
        userDetails["LastName"] = LastNameText!.text
        
        createUser(parameters: userDetails){
            code in
                if(code == 200){
                    self.transitionViewController()
                }
                else {
                    self.showAlert(title: "Issue Signing You Up!")
            }
        }
    }
    
    func transitionViewController(){
         let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         if let mainVc = storyBoard.instantiateViewController(withIdentifier: "LoginController") as? ViewController{
             self.present(mainVc, animated: true, completion: nil)
         }
         
     }
    
    func showAlert(title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
}
