//
//  CityWeatherRealm.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 20.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation
import RealmSwift

class Weather: Object {
    @objc dynamic var cityName: String = ""
    @objc dynamic var tempreture: Int = 0
    @objc dynamic var windSpeed: Double = 0
    @objc dynamic var windDirection: String = ""
}
