//
//  CityWeather.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 15.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation

struct CityWeather: Decodable {
    var name: String
    var main: Tempreture
    var wind: WindInfo
}

struct Tempreture: Decodable {
    var temp: Double
}

struct WindInfo: Decodable {
    var speed: Double
    var deg: Int
}
