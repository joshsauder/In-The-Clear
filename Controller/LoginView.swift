//
//  LoginView.swift
//  InTheClear
//
//  Created by Josh Sauder on 1/12/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit

class LoginView: UIView {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var registerEmailText: UITextField!
    @IBOutlet weak var registerPasswordText: UITextField!
    @IBOutlet weak var registerFirstText: UITextField!
    @IBOutlet weak var registerLastText: UITextField!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpText()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setUpText(){
        emailText.allowsEditingTextAttributes = true
        passwordText.allowsEditingTextAttributes = true
        registerEmailText.allowsEditingTextAttributes = true
        registerPasswordText.allowsEditingTextAttributes = true
        registerFirstText.allowsEditingTextAttributes = true
        registerLastText.allowsEditingTextAttributes = true
    }
    
    
}
