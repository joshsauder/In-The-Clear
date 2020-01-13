//
//  LoginController.swift
//  InTheClear
//
//  Created by Josh Sauder on 1/12/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices

class LoginController: UIViewController {
    
    @IBOutlet weak var InputView: UIView!
    @IBOutlet weak var AppleButtonView: UIStackView!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var ToggleButton: UIButton!
    
    var loginView: LoginView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSignInAppleButton()
        setToLogin()
    }
    
    func setToLogin(){
        loginView = Bundle.main.loadNibNamed("Login", owner: nil, options: nil)?[0] as! LoginView
        loginView.frame = InputView.bounds
        loginView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        InputView.addSubview(loginView);
        
        ToggleButton.setTitle("Register", for: .normal)
    }
    
    func setToRegister(){
        
        loginView = Bundle.main.loadNibNamed("Register", owner: nil, options: nil)?[0] as! LoginView
        loginView.frame = InputView.bounds
        loginView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        InputView.addSubview(loginView);
        ToggleButton.setTitle("Login", for: .normal)
        
    }
    
    @IBAction func SubmitClick(_ sender: Any) {
        
        if(ToggleButton.titleLabel!.text == "Register"){
            print(loginView.emailText!.text)
            print(loginView.passwordText!.text)
        }else {
            print(loginView.registerEmailText!.text)
            print(loginView.registerLastText!.text)
        }
    }
    
    @IBAction func RenderClick(_ sender: Any) {
        ToggleButton.titleLabel?.text == "Register" ? setToRegister() : setToLogin()
        
    }
    
    
}

extension LoginController: ASAuthorizationControllerDelegate {
    
    func setUpSignInAppleButton() {
        
        let authButton = ASAuthorizationAppleIDButton()
        
        authButton.addTarget(self, action: #selector(handleAppleAuth), for: .touchUpInside)
        
        self.AppleButtonView.addArrangedSubview(authButton)
    }
    
    @objc func handleAppleAuth(){
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("\(userIdentifier) \(String(describing: fullName)) \(String(describing: email))")
        
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print(error)
    }
    
}

extension LoginController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
