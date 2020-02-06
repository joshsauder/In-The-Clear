//
//  LoginAPIRequests.swift
//  InTheClear
//
//  Created by Josh Sauder on 1/14/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct User: Encodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}

protocol LoginAPI {
    func signInUser(parameters: User, completion: @escaping (String, String) -> ())
    func createUser(parameters: User, completion: @escaping (Int) -> ())
}

extension LoginAPI {
    
    func signInUser(parameters: User, completion: @escaping (String, String) -> ()){
        
        
        AF.request("http://localhost:5000/api/User/Auth", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().responseJSON {
            response in
            
            if(response.response?.statusCode != 200){
                completion("", "")
            }
            
            let json = JSON(response.data!)
            completion(json["id"].stringValue, json["firstName"].stringValue)
        }
    }
    
    
    func createUser(parameters: User, completion: @escaping (Int) -> ()){
        
        AF.request("http://localhost:5000/api/User", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).validate().responseJSON {
            response in
            
            print((response.response?.statusCode)!)
            
            completion((response.response?.statusCode)!)
        }
    }
}

extension LoginController : LoginAPI {}
extension RegisterViewController : LoginAPI {}
