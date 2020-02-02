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
import GoogleSignIn

class LoginController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var InputView: UIView!
    @IBOutlet weak var AppleButtonView: UIStackView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var ToggleButton: UIButton!
    
    var loginView: LoginView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
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
            var userDetails = [String:String]()
            userDetails["Email"] = loginView.emailText!.text
            userDetails["Password"] = loginView.passwordText!.text
            signInUser(parameters: userDetails) {Id, name in
                if(Id != ""){
                    self.transitionViewController()
                }else {
                    self.showAlert(title: "Incorrect Password")
                }
            }
        }else {
            
            var userDetails = [String: String]()
            userDetails["Email"] = loginView.registerEmailText!.text
            userDetails["Password"] = loginView.registerPasswordText!.text
            userDetails["FirstName"] = loginView.registerFirstText!.text
            userDetails["LastName"] = loginView.registerLastText!.text
            userDetails["Paid"] = "true"
            
            createUser(parameters: userDetails)
            {login in
                if(login == 200){
                    self.signInUser(parameters: userDetails){
                        Id, name in
                        self.transitionViewController()
                    }
                } else {
                    self.showAlert(title: "Incorrect Password")
                }
            }
        }
    }
    
    @IBAction func RenderClick(_ sender: Any) {
        ToggleButton.titleLabel?.text == "Register" ? setToRegister() : setToLogin()
        
    }
    
    func transitionViewController(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let mainVc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as? ViewController{
            self.present(mainVc, animated: true, completion: nil)
        }
        
    }
    
    func showAlert(title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
