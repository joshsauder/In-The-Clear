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
import Alamofire
import SwiftyJSON

class LoginController: UIViewController {
    
    @IBOutlet weak var AppleButtonView: UIStackView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    
    let defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initGoogle()
        createButton(button: SubmitButton)
        addTargets()
        setUpSignInAppleButton()
    }
    
    @IBAction func SubmitClick(_ sender: Any) {
        
        let userDetails = User(email: EmailText!.text!, password: PasswordText!.text!, firstName: "", lastName: "")
        signInUser(parameters: userDetails) {Id, name in
            if(Id != ""){
                self.defaults.set(Id, forKey: Defaults.id)
                self.defaults.set(name, forKey: Defaults.user)
                self.transitionViewController()
            }else {
                self.showAlert(title: "Incorrect Password")
            }
        }
    }
    
    func transitionViewController(){
         
        weak var pvc = self.presentingViewController
        self.dismiss(animated: true, completion: {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController")
            vc.modalPresentationStyle = .fullScreen
            pvc?.present(vc, animated: true, completion: nil)
        })
     }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if EmailText.text!.isEmpty || PasswordText.text!.isEmpty {
            SubmitButton.isEnabled = false
        }else {
            SubmitButton.isEnabled = true
        }
    }
    
    func addTargets(){
        EmailText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        PasswordText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
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


extension LoginController : GIDSignInDelegate {
    
    func initGoogle(){
        GIDSignIn.sharedInstance()?.clientID = Constants.GOOGLE_SIGNIN_KEY
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        
        let idToken = user.authentication.idToken!
        signInGoogleUser(token: idToken, completion: {id,name in
            self.defaults.set(id, forKey: Defaults.id)
            self.defaults.set(name, forKey: Defaults.user)
            self.transitionViewController()
        })
    }
}
