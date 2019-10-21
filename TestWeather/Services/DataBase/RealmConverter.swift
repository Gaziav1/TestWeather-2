//
//  RealmConverter.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 20.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConverter {
    
    static let shared = RealmConverter()
    
    private init(){}
    
    func convertModel(_ weather: CityWeather) -> Weather {
        let city = Weather()
        city.cityName = weather.name
        city.tempreture = Int(weather.main.temp)
        city.windSpeed = weather.wind.speed
        
        city.windDirection = WindDirection.defineWindDirection(weather.wind.deg)
        
        return city
    }
    
}
