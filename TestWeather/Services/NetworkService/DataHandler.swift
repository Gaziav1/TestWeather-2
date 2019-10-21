//
//  DataDecoder.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 18.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation

protocol JsonDataDecoder {
    var networkFetcher: Networking { get }
    func fetchAndDecode<T: Decodable>(from url: URL, decodeData: T.Type, completion: @escaping (T?, Error?) -> Void)
}

class DataHandler: JsonDataDecoder {
    
    var networkFetcher: Networking
    
    init(networkFetcher: Networking = NetworkManager()) {
        self.networkFetcher = networkFetcher
    }
    
    func fetchAndDecode<T: Decodable>(from url: URL, decodeData: T.Type, completion: @escaping (T?, Error?) -> Void) {
        
        networkFetcher.makeRequest(url: url) { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                case .failure(let error):
                    completion(nil, error)
                case .success(let data):
                    do {
                        let jsonData = try JSONDecoder().decode(decodeData, from: data)
                        completion(jsonData, nil)
                    } catch let error {
                        completion(nil, error)
                    }
                }
            }
        }
    }
}
