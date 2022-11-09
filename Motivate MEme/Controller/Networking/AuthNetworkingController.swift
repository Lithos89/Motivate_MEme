//
//  AuthenticationNetworkingController.swift
//  Motivate MEme
//
//  Created by Eduard Mogos on 2020-07-08.
//  Copyright © 2020 Eduard Mogos. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class AuthNetworkingController {
    
    public class LoginNetworking: NetworkingController {
        
        static func attemptLogin(username: String, password: String, completionClosure: @escaping (Bool) -> ()) {
            
            
            let rawParameters: [String: Encodable] = [
                "username": username,
                "password": password
            ]
            //UNSAFE!!! Fix soon
            let parameters = try! JSONSerialization.data(withJSONObject: rawParameters, options: [])
            
            let headers = [
                "Content-Type": "application/json"
            ]
            
            DispatchQueue.global().async(qos: .utility) {
                (executeURLRequest(urlPath: URLData.login, headers: headers, bodyParams: parameters, method: .post) { (data, response, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        completionClosure(false)
                    } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        do {
                            let officialUsername = try JSON(data: data)["username"].stringValue
                            
                            let resHeaders = response.allHeaderFields
                            
                            guard let authHeader = resHeaders[AnyHashable("Authorization")] as? String else {
                                completionClosure(false)
                                return
                            }
                            
                            let authToken: Substring = authHeader.split(separator: " ")[1]
                            
                            let user: User? = DataController.shared.getUserObject()
                            
                            if let user = user {
                                user.update(username: officialUsername, authToken: String(authToken), loginPreference: nil)
                            } else {
                                DataController.shared.createUserObject(username: officialUsername, authToken: String(authToken), loginPreference: nil)
                            }
                            DispatchQueue.main.async {
                                completionClosure(true)
                            }
                        } catch {
                            completionClosure(false)
                        }
                    }

                })?.resume()
            }
        }
        
        private func updateToken() {
            
        }
    }
    
    private class Signup {
        func attemptCreateAccount(username: String, password: String) {
        }
        
    }
    
}
