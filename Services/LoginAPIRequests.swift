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

protocol LoginAPI {
    func signInUser(parameters: [String: String], completion: @escaping (String, String) -> ())
    
    func createUser(parameters: [String: String], completion: @escaping (Int?) -> ())
}

struct Login: Encodable {
    let email: String
    let password: String
}

extension LoginAPI {
    
    func signInUser(parameters: [String: String], completion: @escaping (String, String) -> ()){
        
        let headers: HTTPHeaders = [
          "Content-Type": "application/json; charset=utf-8"
        ]
        
        let login = Login(email: parameters["email"]!, password: parameters["password"]!)
        
        AF.request("http://localhost:5000/api/User/Auth", method: .post, parameters: login, encoder: JSONParameterEncoder.default).validate().responseJSON {
            response in
            
            if(response.response?.statusCode != 200){
                completion("", "")
            }
            
            let json = JSON(response.data!)
            completion(json["id"].stringValue, json["firstName"].stringValue)
        }
    }
    
    
    func createUser(parameters: [String: String], completion: @escaping (Int?) -> ()){
        
        AF.request("http://localhost:5000/api/User", method: .post, parameters: parameters).validate().responseJSON {
            response in
            
            completion(response.response?.statusCode)
        }
    }
}

extension LoginController : LoginAPI {}
extension RegisterViewController : LoginAPI {}
