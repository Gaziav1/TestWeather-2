//
//  CityTableViewCell.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 15.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    static let cellId = "weatherCell"
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var windDeg: UILabel!
    @IBOutlet weak var windSpeed: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func fillCell(_ weather: Weather) {
        self.cityName.text = weather.cityName
        self.temp.text = String(weather.tempreture)
        self.windDeg.text = weather.windDirection
        self.windSpeed.text = "Wind speed \(weather.windSpeed)"
    }
    
}
