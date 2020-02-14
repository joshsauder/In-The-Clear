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
import CoreData

struct User: Encodable {
    let userId: String
    let email: String
    let name: String
}

protocol LoginAPI {
    func signInUser(parameters: User, token: String, completion: @escaping (String, String) -> ())
}

extension LoginAPI {
    
    func signInUser(parameters: User, token: String, completion: @escaping (String, String) -> ()){
        let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
        AF.request("http://localhost:5000/api/User/Auth", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON {
            response in
            
            if(response.response?.statusCode != 200){
                completion("", "")
            }
            
            let json = JSON(response.data!)
            completion(json["id"].stringValue, json["token"].stringValue)
        }
    }
    
}

extension LoginController : LoginAPI {}
