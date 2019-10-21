//
//  WindDirection.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 20.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation

class WindDirection {
    
    static func defineWindDirection(_ deg: Int) -> String {
        switch deg {
        case 360, 0..<45:
            return "North"
        case 45..<90:
            return "NorthEast"
        case 90..<135:
            return "East"
        case 135..<180:
            return "SouthEast"
        case 180..<225:
            return "South"
        case 225..<270:
            return "SouthWest"
        case 270..<315:
            return "West"
        case 315..<360:
            return "NorthWest"
        default:
            return "Unowned"
        }
    }
}
