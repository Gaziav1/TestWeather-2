//
//  NetworkManager.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 15.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation

protocol Networking {
    func makeRequest(url: URL, request: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager: Networking {
    
    func makeRequest(url: URL, request: @escaping (Result<Data, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard data != nil else {
                request(.failure(error!))
                return
            }
            
            request(.success(data!))
            
        }.resume()
    }
}

