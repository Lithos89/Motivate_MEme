//
//  NetworkingController.swift
//  Motivate MEme
//
//  Created by Eduard Mogos on 2020-08-06.
//  Copyright © 2020 Eduard Mogos. All rights reserved.
//

import Foundation

//might not need to declare internal here
class NetworkingController {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    internal static func executeURLRequest(urlPath: String, queryParams: [URLQueryItem]? = nil, headers: [String : String]? = nil, bodyParams: Data? = nil, method: HTTPMethod = .get, taskClosure: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask? {
        guard let request = setupURLRequest(urlPath: urlPath, queryParams: queryParams, headers: headers, bodyParams: bodyParams, method: method) else {
            return nil
        }
        
        //If greater data security is required change session type to ephemeral
        let defaultSession = URLSession(configuration: .default)
        return defaultSession.dataTask(with: request) { (data, response, error) in
            taskClosure(data, response, error)
        }
        
    }
    
    //Setup as part of the class parent as both info and auth can use this
    internal static func setupURLRequest(urlPath: String, queryParams: [URLQueryItem]?, headers: [String : String]?, bodyParams: Data?, method: HTTPMethod? = .get) -> URLRequest? {
        guard let urlComponents = URLComponents(string: urlPath) else { return nil }
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        
        if method != .get { request.httpMethod = method?.rawValue }
        
        if let headers = headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        if let bodyParams = bodyParams { request.httpBody = bodyParams }
        
        return request
    }
}
