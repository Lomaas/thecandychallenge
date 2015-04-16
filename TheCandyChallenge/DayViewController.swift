//
//  DayViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 11/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DayViewController: UIViewController, WeatherServiceDelegate, CLLocationManagerDelegate {
    var blueCloud: UIImageView?
    var viewDidDisapper: Bool = false
    var weatherService: WeatherService?
    let locationManager = CLLocationManager()

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var mainWeatherImage: UIImageView!
    @IBOutlet weak var interactionButton: UIButton!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var mainText: UILabel!

    @IBAction func interactionButtonPressed(sender: UIButton) {
        println("Interaction button pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherService = WeatherService()
        weatherService!.delegate = self
        
        isEarlyDay() ? showEarlyDayScreen() : showLateDayScreen()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewDidDisapper = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        viewDidDisapper = true
    }
    
    func isCloudy() -> Bool {
        return true
    }
    
    func isSunny() -> Bool {
        return false
    }
    
    func isEarlyDay() -> Bool {
        let components = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitSecond | NSCalendarUnit.CalendarUnitMinute
        let date = NSCalendar.currentCalendar().components(components, fromDate: NSDate())
        
        
        if date.hour >= 21 {
            println("IS easrly day view: \(date.hour)")
            return false
        }
        println("Is late day view: \(date.hour)")

        return true
    }
    
    // MARK: Show and add views
    
    func showSun() {
        mainWeatherImage.image = UIImage(named: "sunandcloud")
    }
    
    func showClouds() {
        for x in 0...5 {
            addNewCloud()
        }
    }
    
    func showRain() {
        var updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "addNewRainDrop", userInfo: nil, repeats: true)
    }
    
    func addNewCloud() {
        let size = Int.random(50...140)
        let cloud =  UIImageView(frame: CGRectMake(CGFloat(-140), CGFloat(Int.random(20...150)), CGFloat(size), CGFloat(size)))
        cloud.alpha = 0.8
        cloud.image = UIImage(named: "bluecloud")
        cloud.contentMode = .ScaleAspectFit
        cloud.layer.zPosition = 1;
        self.view.addSubview(cloud)
        
        animateCloud(cloud)
    }
    
    
    func addNewRainDrop() {
        let rainView = RainView(frame: self.view.bounds)
        rainView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(rainView)
        self.view.sendSubviewToBack(rainView)
        self.animateRain(rainView)
    }
    
    // MARK: - animation
    
    func animateCloud(view: UIImageView) {
        let delay = Int.random(0...7)
        let duration = Int.random(13...15)
        animateFrame(view, duration: Double(duration), delay: Double(delay), completion: { (finished) -> Void in
            if self.viewDidDisapper != true {
                view.removeFromSuperview()
                self.addNewCloud()
            }
        })
    }
    
    func animateRain(view: RainView) {
        UIView.animateWithDuration(4, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            var viewFrame = view.frame
            viewFrame.origin.y = self.view.frame.size.height
            view.frame = viewFrame
            }, completion: { finished in
                view.removeFromSuperview()
        })
    }
    
    func animateFrame(view: UIView, duration: Double, delay: Double, completion: (finished: Bool) -> Void) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveLinear, animations: {
            var viewFrame = view.frame
            viewFrame.origin.x = self.view.frame.size.width
            view.frame = viewFrame
            }, completion: { finished in
                completion(finished: finished)
        })
    }
    
    func updateView(imageName: String, text: String, backgroundName: String?) {
        headerImage.image = UIImage(named: imageName)
        mainText.text = text
        
        if let backgroundName = backgroundName {
            background.image = UIImage(named: backgroundName)
        }
    }
    
    func showEarlyDayScreen() {
        interactionButton.hidden = true
        var text: String
        var image: String
        var backgroundName: String?
        let dayOfWeek: Int = getWeekDay(NSDate())
        println("DayOf Week: \(dayOfWeek)")
        self.view.backgroundColor = UIColor(red: 6.0/255.0, green: 138.0/255.0, blue: 194.0/255.0, alpha: 0.5)

        switch dayOfWeek {
        case Days.monday:
            println("Monday")
            image = "monday"
            text = NSLocalizedString("Its monday baby! Stay healthy, avoid spiking blood sugar, stay away from the candy, and you will be fine.", comment: "")
            backgroundName = "background3"
        case Days.tuesday:
            image = "tuesday"
            text = NSLocalizedString("Its tuesday. There are always sales on candy. You will regret i badly", comment: "")
        case Days.wedensday:
            image = "wedensday"
            text = NSLocalizedString("Sugar rush sugar crush... hope its not raining", comment: "")
        case Days.thursday:
            image = "thursday"
            text = NSLocalizedString("Its thursday! Stay healthy, avoid spiking blood sugar, stay away from the candy, and you will be fine.", comment: "")
            backgroundName = "background3"
        case Days.friday:
            image = "friday"
            text = NSLocalizedString("Aaaaah! Weekend is here. Your first real test", comment: "")
            backgroundName = "background3"
        case Days.saturday:
            image = "saturday"
            text = NSLocalizedString("Today you´ll have MASSIVE cravings for candy! Can you stay away?", comment: "")
            backgroundName = "background3"
        case Days.sunday:
            image = "sunday"
            text = NSLocalizedString("Sunday funday! Go out and enjoy the world", comment: "")
            backgroundName = "venezia"
        default:
            println("Did not match any days \(dayOfWeek)")
            fatalError("No matching weekday found")
        }
        
        updateView(image, text: text, backgroundName: backgroundName)
    }
    
    func showLateDayScreen() {
        var text: String
        var image: String
        var backgroundName: String?
        
        interactionButton.hidden = false
        interactionButton.setTitle(NSLocalizedString("No candy for me today?", comment: ""), forState: UIControlState.Normal)
        self.view.backgroundColor = UIColor(red: 44.0/255.0, green: 62/255.0, blue: 80/255.0, alpha: 1)
        mainWeatherImage.image = UIImage(named: "moon")
        mainText.textColor = UIColor.whiteColor()
        let dayOfWeek: Int = getWeekDay(NSDate())
        
        switch dayOfWeek {
        case Days.monday:
            image = "monday"
            text = NSLocalizedString("An easy day huh? Monday isnt a problem. You just had weekend", comment: "")
        case Days.tuesday:
            image = "tuesday"
            text = NSLocalizedString("Did you see any candy offers today? And you resisted them. Well done", comment: "")
        case Days.wedensday:
            image = "wedensday"
            text = NSLocalizedString("Oh so you did avoid your coworkers well meant offer", comment: "")
        case Days.thursday:
            image = "thursday"
            text = NSLocalizedString("Bragging right is everything. ", comment: "")
        case Days.friday:
            image = "friday"
            text = NSLocalizedString("You are brilliant", comment: "")
        case Days.saturday:
            image = "saturday"
            text = NSLocalizedString("I guess you had massive CRAVINGS today I congratulate you if you made it. By the way, you owe me if you are lying", comment: "")
        default:
            println("Did not match any days \(dayOfWeek)")
            fatalError("No matching weekday found")
        }
        
        updateView(image, text: text, backgroundName: backgroundName)
    }
    
    func shouldShowEarlyDayScreen() -> Bool {
        return true
    }
    
    func getWeekDay(date: NSDate) -> Int {
        let myComponents = NSCalendar.currentCalendar().component(NSCalendarUnit.WeekdayCalendarUnit, fromDate: date)
        return myComponents
    }
    
    func localWeather(weather: Weather) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            switch weather {
            case Weather.clear:
                println("Weather is clear")
            case Weather.sunny:
                self.showSun()
            case Weather.cloudy:
                self.showClouds()
            case Weather.rain:
                self.showRain()
            default:
                println("Weather view not implemented yet")
            }
        })
    }
}