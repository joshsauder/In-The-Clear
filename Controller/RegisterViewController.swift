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
        createButton(button: SubmitButton)
        disableButton(button: SubmitButton)
    }
    
    
    func transitionViewController(){
        weak var pvc = self.presentingViewController
        self.dismiss(animated: true, completion: {
            let storyboard = UIStoryboard(name: "StartView", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginController")
            pvc?.present(vc, animated: true, completion: nil)
        })
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
