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
    
    @IBOutlet weak var AppleButtonView: UIStackView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        addTargets()
        setUpSignInAppleButton()
    }
    
    @IBAction func SubmitClick(_ sender: Any) {
        
        var userDetails = [String:String]()
        userDetails["Email"] = EmailText!.text
        userDetails["Password"] = PasswordText!.text
        signInUser(parameters: userDetails) {Id, name in
            if(Id != ""){
                self.transitionViewController()
            }else {
                self.showAlert(title: "Incorrect Password")
            }
        }
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
    
    @objc func textFieldDidChange(textField: UITextField) {
        if EmailText.text!.isEmpty || PasswordText.text!.isEmpty {
            SubmitButton.isEnabled = false
        }else {
            SubmitButton.isEnabled = true
        }
    }
    
    func addTargets(){
        EmailText.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        PasswordText.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
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
