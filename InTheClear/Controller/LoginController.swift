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
import Firebase
import CryptoKit

class LoginController: UIViewController {
    
    @IBOutlet weak var AppleButtonView: UIStackView!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var SunArrowView: UIImageView!
    @IBOutlet weak var StormArrowView: UIImageView!
    
    @IBOutlet weak var StormArrowTrailingContstraint: NSLayoutConstraint!
    @IBOutlet weak var SunArrowLeadingConstraint: NSLayoutConstraint!
    
    var spinner: UIView?
    
    var handle: AuthStateDidChangeListenerHandle?
    fileprivate var currentNonce: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initGoogle()
        setUpSignInAppleButton()
        addStateListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //initialize animating arrows location
        self.initArrowPosition()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //show the animating arrows
        self.showArrows()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    /**
     Transitions to Main View Controller
     */
    func transitionViewController(){
        let storyBoard = UIStoryboard(name: "TabBarView", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "TabBarController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
     }
    
    /**
     Listens for a user Sign in and if valid, shows the main view controller
     */
    func addStateListener(){
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if let user = user {
                //show spinner during login
                self.spinner = self.showSpinner(view: self.view)
                
                let parameters = User(paid: true, email: user.email!, displayName: user.displayName != nil ? user.displayName! : "")
                user.getIDTokenForcingRefresh(true){ idToken, error in
                    if error != nil {
                        self.stopSpinner(spinner: self.spinner)
                        self.spinner = nil
                        
                        self.present(self.showAlert(title: "Issue Signing You In! Please Try Again.", message: ""), animated: true)
                        return;
                        
                    }
                    else{
                        let tempUser = self.getUserData()
                        //check if user already signed in
                        if(tempUser.email != user.email){
                            self.newUser(parameters: parameters, idToken: idToken!) { id in
                                self.getUserTrips(id: id, token: idToken!, completion: {
                                    self.transitionViewController()
                                })
                            }
                        }
                        else {
                            let manger = RealmManager()
                            manger.resetTrips()
                            self.getUserTrips(id: tempUser.id, token: idToken!, completion: {
                                self.transitionViewController()
                            })
                        }
                    }
                }
            }
            
        }
    }
    
    /**
     Gets user data when it is not in Realm cache
     - parameters  :
        - parameters: user details
        - idToken: Auth Token
        - completion: Returns the user id on completion
     */
    func newUser(parameters: User, idToken: String, completion: @escaping  (String) -> ()){
        self.signInUser(parameters: parameters, token: idToken){ (id, name, email, createdAt) in
            if(id == ""){
                self.stopSpinner(spinner: self.spinner)
                self.spinner = nil
                self.present(self.showAlert(title: "Issue Signing You In! Please Try Again.", message: ""), animated: true)
                return;
            }else {
                //add data to Realm
                self.stopSpinner(spinner: self.spinner)
                
                self.spinner = nil
                self.saveData(token: idToken, id: id, name: name, email: email, createdAt: self.formatDate(date: createdAt))
                completion(id)
            }
        }
    }
    
    private func formatDate(date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        return dateFormatter.date(from: date) ?? Date()
    }
    
    /**
     Save User Data to Realm
     */
    private func saveData(token: String, id: String, name: String, email: String, createdAt: Date) {
        let manager = RealmManager()
        
        let data = manager.initUserData(id: id, name: name, token: token, email: email, createdAt: createdAt)
        manager.writeUser(user: data)
    }
    
    /**
     Gets User Data
     - Returns: The user's data
     */
    private func getUserData() -> UserData{
        let manager = RealmManager()
        return manager.getUser()
    }
        
}

/**
 Recommended Procedure to Sign in With Apple using Firebase
 */
extension LoginController: ASAuthorizationControllerDelegate {
    
    func setUpSignInAppleButton() {
        
        let authButton = ASAuthorizationAppleIDButton()
        authButton.addTarget(self, action: #selector(handleAppleAuth), for: .touchUpInside)
        self.AppleButtonView.addArrangedSubview(authButton)
    }
    
    @objc func handleAppleAuth(){
        
        currentNonce = randomNonceString()
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(currentNonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            
            guard let appleIDToken = appleIDCredential.identityToken else {
              print("Unable to fetch identity token")
              return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: currentNonce)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.present(self.showAlert(title: "Invalid Sign In", message: ""), animated: true)
                    return
                }
            }
        
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.present(self.showAlert(title: "Issue Signing You In! Please Try Again.", message: ""), animated: true)
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}

extension LoginController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


extension LoginController : GIDSignInDelegate {
    
    /**
     Initialize Sign in With Google Button
     */
    func initGoogle(){
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        self.signInButton.style = GIDSignInButtonStyle.wide
    }

    /**
    Handle Google Sign in
    */
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        
        let creds = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        
        Auth.auth().signIn(with: creds) { (authResult, error) in
            if error != nil {
                self.present(self.showAlert(title: "Invalid Sign In", message: ""), animated: true)
                return
            }
        }
    }
}

