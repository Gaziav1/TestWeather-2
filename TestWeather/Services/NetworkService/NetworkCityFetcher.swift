//
//  NetworkCityFetcher.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 18.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation

class NetworkCityFetcher {
    
    static let shared = NetworkCityFetcher()
    
    private let dataHandler = DataHandler()
    private init(){}
    
    public func fetchCity(for city: String, completion: @escaping (City?, Error?) -> Void) {
    
        let params = ["limit": "5",
                      "namePrefix": city]
        
        let path = APIPath(scheme: "http", endpoint: "geodb-free-service.wirefreethought.com", path: "/v1/geo/cities", params: params)
        
        guard let url = path.createUrl() else { return }
        
        dataHandler.fetchAndDecode(from: url, decodeData: City.self) { (city, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            completion(city, nil)
        }
    }
}
