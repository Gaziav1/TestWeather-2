//
//  DataBaseManager.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 20.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    private var realm: Realm
    
    static let sharedInstance = RealmManager()
    
    private init() {
        realm = try! Realm()
    }
    
    
    func add(_ object: Object) {
        
        try! realm.write {
            realm.add(object)
        }
    }
    
    func delete(_ object: Object) {
        
        try! realm.write{
            realm.delete(object)
        }
    }
    
    func get(of type: Object.Type) -> Results<Object> {
        let data = realm.objects(type.self)
        return data
    }
    
    func updateData(wtih newWeather: Weather) {
        
        let objects = realm.objects(Weather.self).filter("cityName = %@", newWeather.cityName)

        if let oldWeather = objects.first {
            try! realm.write {
                oldWeather.tempreture = newWeather.tempreture
                oldWeather.windDirection = newWeather.windDirection
                oldWeather.windSpeed = newWeather.windSpeed
            }
        }
    }
}
