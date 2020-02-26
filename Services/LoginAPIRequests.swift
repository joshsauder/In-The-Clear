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
    let paid: Bool
    let email: String
    let displayName: String
}

protocol LoginAPI {
    func signInUser(parameters: User, token: String, completion: @escaping (String, String) -> ())
}

extension LoginAPI {
    
    func signInUser(parameters: User, token: String, completion: @escaping (String, String) -> ()){
        let headers: HTTPHeaders = ["Authorization": "Bearer " + token]
        print(token)
        AF.request("https://app.intheclearapp.com/api/User/Auth", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON {
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
