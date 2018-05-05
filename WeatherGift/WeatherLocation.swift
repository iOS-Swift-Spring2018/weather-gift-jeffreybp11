//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Jeffrey Barros Peña on 3/25/18.
//  Copyright © 2018 Barros Peña. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    var name = ""
    var coordinates = ""
    var currentTemp = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = "q"
    
    func getWeather(completed: @escaping () -> ()) {
        let weatherURL = urlBase + urlAPIKey + coordinates        
        Alamofire.request(weatherURL).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    print("***** temperature inside getWeather: \(temperature)")
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°"
                } else {
                    print("Could not return a temperature")
                }
                if let summary = json["daily"]["summary"].string {
                    self.currentSummary = summary
                } else {
                    print("Could not return a summary")
                }
                if let icon = json["currently"]["icon"].string {
                    self.currentIcon = icon
                } else {
                    print("Could not return an icon")
                }
                if let timeZone = json["timezone"].string {
                    self.timeZone = timeZone
                } else {
                    print("Could not return a timezone")
                }
                if let time = json["currently"]["time"].double {
                    self.currentTime = time
                } else {
                    print("Could not return a time")
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
