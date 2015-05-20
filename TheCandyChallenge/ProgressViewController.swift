//
//  ProgressViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 01/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

struct Days {
    static let sunday = 1
    static let monday = 2
    static let tuesday = 3
    static let wedensday = 4
    static let thursday = 5
    static let friday = 6
    static let saturday = 7
}

class ProgressViewController: UIViewController {
    var challenge: PFObject?
    var itemIndex: Int = 1

    @IBOutlet weak var dayViewContainer: UIView!
    @IBOutlet weak var moneySaved: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserChallengeService.getMyChallengeFromLocalStorage({ (userChallenge: PFObject) -> Void in
            self.challenge = userChallenge
            var f: String = self.challenge!.objectId!
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
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            println("Day since started: \(self.challenge!.createdAt)")
    //        calories.text = challenge?["calories"] as? String
            self.daysLabel.text = self.getDaysSinceStarted(self.challenge!.createdAt!)
    //        moneySaved.text = challenge?["moneySaved"] as? String
        })
    }
    
    func getDaysSinceStarted(date: NSDate) -> String {
        let components = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitSecond | NSCalendarUnit.CalendarUnitMinute
        let date = NSCalendar.currentCalendar().components(components, fromDate: date, toDate: NSDate(), options: nil)
        return "\(date.day) days  \(date.hour) hours \(date.minute) minutes"
    }
}