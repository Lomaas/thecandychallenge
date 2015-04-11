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
    var challenge: PFObject?
    
    @IBOutlet weak var dayViewContainer: UIView!
    @IBOutlet weak var moneySaved: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HealthKitService().authorizeHealthKit { (authorized, error) -> Void in
            if authorized {
                println("HealthKit authorization received.")
                HealthKitService().readMostRecentSample(, completion: { (sample, error) -> Void in
                    
                })
            }
            else
            {
                println("HealthKit authorization denied!")
                if error != nil {
                    println("\(error)")
                }
            }
        }
        
        UserChallengeService.getMyChallengeFromLocalStorage({ (userChallenge: PFObject) -> Void in
            self.challenge = userChallenge
            var f: String = self.challenge!.objectId
            println("Has challenge with objectID: \(f)")
            userChallenge.pinInBackground()
            self.updateScreen()
            
        }, errorHandler: { () -> Void in
            UserChallengeService.getMyChallenge({ (userChallenge: PFObject) -> Void in
                self.challenge = userChallenge
                self.updateScreen()
            })
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateScreen() {
        if shouldShowDayView() { showDayView() }
        
//        calories.text = challenge?["calories"] as? String
        daysLabel.text = getDaysSinceStarted(challenge!.createdAt!)
//        moneySaved.text = challenge?["moneySaved"] as? String
    }
    
    func getDaysSinceStarted(date: NSDate) -> String {
        let components = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitSecond | NSCalendarUnit.CalendarUnitMinute
        let date = NSCalendar.currentCalendar().components(components, fromDate: date, toDate: NSDate(), options: nil)
        return "\(date.day) days  \(date.hour) hours \(date.minute) minutes"
    }
    
    func shouldShowDayView() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()

        if defaults.objectForKey("seenTodayView") != nil {
            defaults.setObject("yes", forKey: "seenTodayView")
            NSUserDefaults.standardUserDefaults().synchronize()
            return true
        }
        else {
            return false
        }
    }
    
    func showDayView() {
        performSegueWithIdentifier("dayViewController", sender: self)
    }
}