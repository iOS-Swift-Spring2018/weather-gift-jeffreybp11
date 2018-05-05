//
//  DetailVC.swift
//  WeatherGift
//
//  Created by Jeffrey Barros Peña on 3/17/18.
//  Copyright © 2018 Barros Peña. All rights reserved.
//

import UIKit
import CoreLocation

class DetailVC: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var currentImage: UIImageView!
    
    var currentPage = 0
    var locationsArray = [WeatherLocation]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentPage != 0 {
            self.locationsArray[currentPage].getWeather {
                self.updateUI()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentPage == 0 {
            getLocation()
        }
    }
    
    func updateUI() {
        let location = locationsArray[currentPage]
        let dateString = formatTimeForTimeZone(unixDate: location.currentTime, timeZone: location.timeZone)
        dateLabel.text = dateString
        locationLabel.text = location.name
        dateLabel.text = location.coordinates
        temperatureLabel.text = location.currentTemp
        summaryLabel.text = location.currentSummary
        currentImage.image = UIImage(named: location.currentIcon)
    }
    func formatTimeForTimeZone(unixDate: TimeInterval, timeZone: String) -> String {
        let usableDate = Date(timeIntervalSince1970: unixDate)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM dd, y"
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let dateString = dateFormatter.string(from: usableDate)
        return dateString
    }
}

extension DetailVC: CLLocationManagerDelegate {
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func handleLocationAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            print("I'm sorry - Cannot show location. User has not authorized it.")
        case .restricted:
            print("Access denied. Likely parental controls restrict location services for this application.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        var place = ""
        currentLocation = locations.last
        let currentLongitude = currentLocation.coordinate.longitude
        let currentLatitude = currentLocation.coordinate.latitude
        let currentCoordinates = "\(currentLatitude),\(currentLongitude)"
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: {
            placemarks, error in
            if placemarks != nil {
                let placemark = placemarks?.last
                place = (placemark?.name)!
            } else {
                print("Error retrieving place. Error code: \(error!)")
                place = "Unknown Weather Location"
            }
            self.locationsArray[0].name = place
            self.locationsArray[0].coordinates = currentCoordinates
            self.locationsArray[0].getWeather {
              self.updateUI()
            }
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location.")
    }
}
