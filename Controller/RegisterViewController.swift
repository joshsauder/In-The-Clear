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
        
        let userDetails = User(email: EmailText!.text!, password: EmailText!.text!, firstName: PasswordText!.text!, lastName: LastNameText!.text!)
        
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
        weak var pvc = self.presentingViewController
        self.dismiss(animated: true, completion: {
            let storyboard = UIStoryboard(name: "StartView", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginController")
            pvc?.present(vc, animated: true, completion: nil)
        })
     }
    
    func showAlert(title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        if EmailText.text!.isEmpty || PasswordText.text!.isEmpty || FirstNameText.text!.isEmpty || LastNameText.text!.isEmpty {
            SubmitButton.isEnabled = false
        }else {
            SubmitButton.isEnabled = true
        }
    }
    
    func addTargets(){
        EmailText.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        PasswordText.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        FirstNameText.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        LastNameText.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }

    
}
