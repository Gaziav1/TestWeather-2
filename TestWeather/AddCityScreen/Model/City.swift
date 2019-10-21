//
//  City.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 17.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation

struct City: Decodable {
    var data: [CityName]
}

struct CityName: Decodable {
    var name: String
    var country: String
    var countryCode: String
}
