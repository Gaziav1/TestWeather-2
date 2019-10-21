//
//  NetworkWeatherFetcher.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 16.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation

class NetworkWeatherFetcher {
    
    static let shared = NetworkWeatherFetcher()
    
    private let apiKey = "56dac6730497f1e7885079b42c8809d7"
    private let dataHandler = DataHandler()
    private init(){}
    
    public func fetchWeather(for city: String, completion: @escaping (CityWeather?, Error?) -> Void) {
        
        let params = ["q": city,
                      "apiKey": apiKey,
                      "units": "metric"]
        
        let path = APIPath(scheme: "https", endpoint: "api.openweathermap.org", path: "/data/2.5/weather", params: params)
       
        guard let url = path.createUrl() else { return }
    
        dataHandler.fetchAndDecode(from: url, decodeData: CityWeather.self) { (city, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            completion(city, nil)
        }
    }
}

