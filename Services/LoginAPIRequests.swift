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

extension LoginController {
    
    func signInUser(parameters: [String: String], completion: @escaping (String, String) -> ()){
        
        Alamofire.request("http://localhost:5000/api/User/Auth", method: .post, parameters: parameters).validate().responseJSON {
            response in
            
            if(response.response?.statusCode != 200){
                completion("", "")
            }
            
            let json = JSON(response.data!)
            completion(json["Id"].stringValue, json["FirstName"].stringValue)
        }
    }
    
    
    func createUser(parameters: [String: String], completion: @escaping (Int?) -> ()){
        
        Alamofire.request("http://localhost:5000/api/User", method: .post, parameters: parameters).validate().responseJSON {
            response in
            
            completion(response.response?.statusCode)
        }
    }
    
    func signInGoogle(token: String, completion: @escaping (String, String) -> ()){
        Alamofire.request("http://localhost:3400/api/User/Auth/Google/?token=\(token)&paid=true", method: .post).validate().responseJSON {
            response in
            
            let json = JSON(response.data!)
            completion(json["Id"].stringValue, json["FirstName"].stringValue)
        }
    }
}
