//
//  DayViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 11/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation
import UIKit

class DayViewController: UIViewController {
    var blueCloud: UIImageView?
    var viewDidDisapper: Bool = false

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var mainWeatherImage: UIImageView!
    @IBOutlet weak var interactionButton: UIButton!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var mainText: UILabel!
    
    @IBAction func isPanning(sender: UIPanGestureRecognizer) {
        println("Ispannign")
    }
    @IBAction func interactionButtonPressed(sender: UIButton) {
        println("Interaction button pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isEarlyDay() ? showEarlyDayScreen() : showLateDayScreen()
        if isCloudy() { showClouds() }
        if isSunny() {  showSun() }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        viewDidDisapper = false
        if isCloudy() { animateBlueCloud() }
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
        
        println("IS easrly day view: \(date.hour)")
        
        if date.hour >= 21 {
            return false
        }
        return true
    }
    
    func showSun() {
        mainWeatherImage.image = UIImage(named: "sunandcloud")
    }
    
    func showClouds() {
        var cloud =  UIImageView(frame: CGRectMake(30, 30, 100, 100))
        cloud.image = UIImage(named: "bluecloud")
        cloud.contentMode = .ScaleAspectFit
        cloud.layer.zPosition = 1;
        blueCloud = cloud
        self.view.addSubview(blueCloud!)
    }
    
    func stopAnimation() {
        
    }
    
    func animateBlueCloud() {
        if let blueCloud = blueCloud {
            animateFrame(blueCloud, completion: { (finished) -> Void in
                if self.viewDidDisapper != true {
                    var viewFrame = blueCloud.frame
                    viewFrame.origin.x = -100
                    blueCloud.frame = viewFrame
                    self.animateBlueCloud()
                }
            })
        }
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
        var backgroundName: String
        let dayOfWeek: Int = getWeekDay(NSDate())
        println("DayOf Week: \(dayOfWeek)")
        
        switch dayOfWeek {
        case Days.monday:
            println("Monday")
            image = "monday"
            text = NSLocalizedString("Its monday baby! Stay healthy, avoid spiking blood sugar, stay away from the candy, and you will be fine.", comment: "")
            backgroundName = "background3"
        case Days.tuesday:
            image = "tuesday"
            text = NSLocalizedString("Its tuesday. Hope you can stay away from candy offers", comment: "")
            backgroundName = "background1"
        case Days.wedensday:
            image = "wedensday"
            text = NSLocalizedString("Dont you hate when someone offers you candy? It is hard to resist and you dont want to be unpolite?", comment: "")
            backgroundName = "background1"
        case Days.thursday:
            image = "thursday"
            text = NSLocalizedString("Fake it until you make it them say. Well here you have to stick with it", comment: "")
            backgroundName = "background1"
        case Days.friday:
            image = "friday"
            text = NSLocalizedString("Aaaaah! Weekend is here. Your first real test", comment: "")
            backgroundName = "background1"
        case Days.saturday:
            image = "saturday"
            text = NSLocalizedString("Today you´ll have MASSIVE cravings for candy! Can you stay away?", comment: "")
            backgroundName = "background2"
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
        var backgroundName: String
        interactionButton.hidden = false
        interactionButton.setTitle(NSLocalizedString("No candy for me today!", comment: ""), forState: UIControlState.Normal)
        let dayOfWeek: Int = getWeekDay(NSDate())
        
        switch dayOfWeek {
        case Days.monday:
            println("Monday")
            headerImage.image = UIImage(named: "monday")
            mainText.text = NSLocalizedString("An easy day huh? Monday isnt a problem. You just had weekend", comment: "")
        case Days.tuesday:
            image = "tuesday"
            text = NSLocalizedString("Did you see any candy offers today? And you resisted them. Well done", comment: "")
            backgroundName = "background1"
        case Days.wedensday:
            image = "wedensday"
            text = NSLocalizedString("Oh so you did avoid your coworkers well meant offer", comment: "")
            backgroundName = "background1"
        case Days.thursday:
            image = "thursday"
            text = NSLocalizedString("Bragging right is everything", comment: "")
            backgroundName = "background1"
        case Days.friday:
            image = "friday"
            text = NSLocalizedString("You are brilliant", comment: "")
            backgroundName = "background1"
        case Days.saturday:
            println("Saturday")
            headerImage.image = UIImage(named: "saturday")
            mainText.text = NSLocalizedString("I guess you had massive CRAVINGS today I congratulate you if you made it. By the way, you owe me if you are lying", comment: "")
        default:
            println("Did not match any days \(dayOfWeek)")
        }
    }
    
    func shouldShowEarlyDayScreen() -> Bool {
        return true
    }
    
    func getWeekDay(date: NSDate) -> Int {
        let myComponents = NSCalendar.currentCalendar().component(NSCalendarUnit.WeekdayCalendarUnit, fromDate: date)
        return myComponents
    }
    
    func animateFrame(view: UIView, completion: (finished: Bool) -> Void) {
        UIView.animateWithDuration(15, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            var viewFrame = view.frame
            viewFrame.origin.x = self.view.frame.size.width
            view.frame = viewFrame
            }, completion: { finished in
                completion(finished: finished)
        })
    }
}