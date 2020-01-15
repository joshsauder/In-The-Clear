//
//  LoginAPIRequests.swift
//  InTheClear
//
//  Created by Josh Sauder on 1/14/20.
//  Copyright © 2020 Josh Sauder. All rights reserved.
//

import Foundation
import Alamofire


extension LoginController {
    
    func signInUser(url: String, parameters: [String: String], completion: @escaping (Int?) -> ()){
        
        Alamofire.request(url, method: .post, parameters: parameters).validate().responseJSON {
            response in
            
            completion(response.response?.statusCode)
        }
    }
}
