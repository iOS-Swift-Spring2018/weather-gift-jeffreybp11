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
    var summary = ""
    
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
                self.summary = json["daily"]["summary"].string!
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
