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
}

protocol WeatherServiceDelegate {
    func localWeather(weather: Weather)
}

class WeatherService: NSObject, CLLocationManagerDelegate {
    var delegate: WeatherServiceDelegate?
    var weather: String?
    var isFetchingWeather = false
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        println("\(locations.last)")
        fetchWeather(manager.location.coordinate.latitude, lon: manager.location.coordinate.longitude)
    }
    
    private func fetchWeather(lat: Double, lon: Double) {
        if isFetchingWeather { return }

        if let weather = weather {
            mapWeather(weather)
            return
        }
        
        locationManager.delegate = nil
        isFetchingWeather = true
        
        let url = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)"
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
        if let description = weatherArray[0]["main"] as? String {
            weather = description
            mapWeather(description)
        }
    }
    
    private func mapWeather(description: String) {
        println("Weather: \(description)")
        switch description {
            case "Clear":
                self.delegate?.localWeather(Weather.clear)
            case "Sun":
                self.delegate?.localWeather(Weather.sunny)
            default:
            println("Weather not mapped yet: \(description)")
        }
    }
}