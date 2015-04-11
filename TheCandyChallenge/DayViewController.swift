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
    @IBOutlet weak var interactionButton: UIButton!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var mainText: UILabel!
    
    @IBAction func interactionButtonPressed(sender: UIButton) {
        println("Interaction button pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isEarlyDay() ? showEarlyDayScreen() : showLateDayScreen()
    }

    func isEarlyDay() -> Bool {
        let components = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitSecond | NSCalendarUnit.CalendarUnitMinute
        let date = NSCalendar.currentCalendar().components(components, fromDate: NSDate())
        
        println("IS easrly day view: \(date.hour)")
        
        if date.hour > 21 {
            return false
        }
        return true
    }
    
    func showEarlyDayScreen() {
        interactionButton.setTitle(NSLocalizedString("Dismiss", comment: ""), forState: UIControlState.Normal)
        
        let dayOfWeek: Int = getWeekDay(NSDate())
        
        switch dayOfWeek {
        case Days.monday:
            println("Monday")
            headerImage.image = UIImage(named: "monday")
            mainText.text = NSLocalizedString("Its monday baby! Stay healthy, avoid spiking blood sugar, stay away from the candy, and you will be fine.", comment: "")
        case Days.saturday:
            println("Saturday")
            headerImage.image = UIImage(named: "saturday")
            mainText.text = NSLocalizedString("Today you´ll MASSIVE cravings for candy! Can you stay away?", comment: "")
        default:
            println("Did not match any days \(dayOfWeek)")
        }
    }
    
    func showLateDayScreen() {
        let dayOfWeek: Int = getWeekDay(NSDate())
        
        switch dayOfWeek {
        case Days.monday:
            println("Monday")
            headerImage.image = UIImage(named: "monday")
            mainText.text = NSLocalizedString("An easy day huh? Monday isnt a problem. You just had weekend", comment: "")
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
}