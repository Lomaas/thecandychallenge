//
//  ProgressViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 01/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation
import UIKit


struct Days {
    static let monday = 2
    static let tuesday = 3
    static let wedensday = 4
    static let thursday = 5
    static let friday = 6
    static let saturday = 7
    static let sunday = 1
}

class ProgressViewController: UIViewController {
    var challenge: PFObject? {
        didSet {
            println("Didset progress view")
        }
    }
    
    @IBOutlet weak var dayViewContainer: UIView!
    @IBOutlet weak var moneySaved: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserChallengeService.getMyChallengeFromLocalStorage({ (userChallenge: PFObject) -> Void in
            self.challenge = userChallenge
            var f: String = self.challenge!.objectId
            println("Has challenge with objectID: \(f)")
            self.updateScreen()
            
        }, errorHandler: { () -> Void in
            UserChallengeService.getMyChallenge({ (userChallenge: PFObject) -> Void in
                self.challenge = userChallenge
                self.updateScreen()
            })
        })
    }
    
    func updateScreen() {
        shouldShowEarlyDayScreen() ? showEarlyDayScreen() : showLateDayScreen()
        
        calories.text = challenge?["calories"] as? String
        daysLabel.text = getDaysSinceStarted(challenge!.createdAt!)
        moneySaved.text = challenge?["moneySaved"] as? String
        
        
    }
    
    func showEarlyDayScreen() {
        dayViewContainer.hidden = false
        dayViewContainer.frame = self.view.frame
        
        let dayOfWeek: Int = getWeekDay(NSDate())

        switch dayOfWeek {
        case Days.monday:
            println("Monday")
        case Days.saturday:
            println("Saturday")
        default:
            println("Did not match any days \(dayOfWeek)")
        }
    }
    
    func showLateDayScreen() {
        
    }
    
    func shouldShowEarlyDayScreen() -> Bool {
        return true
    }
    
    func getWeekDay(date: NSDate) -> Int {
        let myComponents = NSCalendar.currentCalendar().component(NSCalendarUnit.WeekdayCalendarUnit, fromDate: date)
        return myComponents
    }
    
    func getDaysSinceStarted(date: NSDate) -> String {
        let components = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitSecond | NSCalendarUnit.CalendarUnitMinute
        let date = NSCalendar.currentCalendar().components(components, fromDate: date, toDate: NSDate(), options: nil)
        return "\(date.day) days  \(date.hour) hours \(date.minute) minutes"
    }
}

public extension NSDate {
    func xDays(x:Int) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: x, toDate: self, options: nil)!
    }
    func xWeeks(x:Int) -> NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitWeekOfYear, value: x, toDate: self, options: nil)!
    }
    var hoursFromToday: Int{
        return NSCalendar.currentCalendar().components(.CalendarUnitHour, fromDate: self, toDate: NSDate(), options: nil).hour
    }
    var daysFromToday: Int{
        return NSCalendar.currentCalendar().components(.CalendarUnitDay, fromDate: self, toDate: NSDate(), options: nil).hour
    }
    var weeksFromToday: Int{
        return NSCalendar.currentCalendar().components(.CalendarUnitWeekOfYear, fromDate: self, toDate: NSDate(), options: nil).weekOfYear
    }
    var relativeDateString: String {
        if weeksFromToday > 0 { return weeksFromToday > 1 ? "\(weeksFromToday) weeks and \(hoursFromToday) hours" : "\(weeksFromToday) week and \(hoursFromToday) hours"   }
        if hoursFromToday > 0 { return hoursFromToday > 1 ? "\(hoursFromToday) hours" : "\(hoursFromToday) hour"   }
        return ""
    }
}