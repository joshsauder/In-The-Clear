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
    }
    
    
}
