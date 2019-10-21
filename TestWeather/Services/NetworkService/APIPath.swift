//
//  API.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 16.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation

protocol URLPath {
    var scheme: String { get }
    var endpoint: String { get }
    var path: String { get }
    var params: [String: String] { get }
}

struct APIPath: URLPath {
    
    let scheme: String
    let endpoint: String
    let path: String
    let params: [String: String]
    
    func createUrl() -> URL? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = endpoint
        urlComponents.path = path
        
        urlComponents.queryItems = params.map( { URLQueryItem(name: $0, value: $1)} )
        
        guard let url = urlComponents.url else { return nil }
        return url
    }
}


