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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        fetchWeather(manager.location.coordinate.latitude, lon: manager.location.coordinate.longitude)
    }
    
    func startFetchingWeather() {
        locationManager.startUpdatingLocation()
    }
    
    private func fetchWeather(lat: Double, lon: Double) {
        print("FetchWeather")
        if isFetchingWeather { return }
        
        locationManager.stopUpdatingLocation()
        isFetchingWeather = true

        let url = "http://api.openweathermap.org/data/2.5/weather?lat=67&lon=15"
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            print("Finished getting weather")
            self.isFetchingWeather = false
            
            print("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            print("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options:nil, error: &err) as? NSDictionary
            
            if(err != nil) {
                print(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                if let weather = json?["weather"] as? NSArray {
                    self.parseJSON(weather)
                }
                else {
                    print("Error could not parse JSON")
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
        print("Weather: \(main), description: \(description)")
        switch main {
            case "Clear":
                self.delegate?.localWeather(Weather.clear)
            case "Sun":
                self.delegate?.localWeather(Weather.sunny)
            case "Rain":
                self.delegate?.localWeather(Weather.rain)
            default:
            print("Weather not mapped yet: \(main)")
        }
    }
}