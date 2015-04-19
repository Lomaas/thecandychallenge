//
//  WeatherService.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 13/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation
import CoreLocation

enum Weather {
    case cloudy
    case sunny
    case clear
    case rain
    case lightRain
}

protocol WeatherServiceDelegate {
    func localWeather(weather: Weather)
}

class WeatherService: NSObject, CLLocationManagerDelegate {
    var delegate: WeatherServiceDelegate?
    var isFetchingWeather = false
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        fetchWeather(manager.location.coordinate.latitude, lon: manager.location.coordinate.longitude)
    }
    
    func startFetchingWeather() {
        locationManager.startUpdatingLocation()
    }
    
    private func fetchWeather(lat: Double, lon: Double) {
        println("FetchWeather")
        if isFetchingWeather { return }
        
        locationManager.stopUpdatingLocation()
        isFetchingWeather = true

        let url = "http://api.openweathermap.org/data/2.5/weather?lat=67&lon=15"
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            println("Finished getting weather")
            self.isFetchingWeather = false
            
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                if let parseJSON = json {
                    if let weather = parseJSON["weather"] as? NSArray {
                        self.parseJSON(weather)
                    }
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        task.resume()
    }
    
    func parseJSON(weatherArray: NSArray) {
        let main = weatherArray[0]["main"] as? String ?? ""
        let description = weatherArray[0]["description"] as? String ?? ""
        mapWeather(main, description: description)
    }
    
    private func mapWeather(main: String, description: String) {
        println("Weather: \(main), description: \(description)")
        switch main {
            case "Clear":
                self.delegate?.localWeather(Weather.clear)
            case "Sun":
                self.delegate?.localWeather(Weather.sunny)
            case "Rain":
                self.delegate?.localWeather(Weather.rain)
            default:
            println("Weather not mapped yet: \(main)")
        }
    }
}