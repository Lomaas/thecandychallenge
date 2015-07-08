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
    var challenge: Challenge!
    var itemIndex: Int = 1

    @IBOutlet weak var dayViewContainer: UIView!
    @IBOutlet weak var moneySaved: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChallengeService.getMyChallenge({ (userChallenge: Challenge) -> Void in
            self.challenge = userChallenge
            print("Has challenge with createdDate: \(self.challenge.createdDate)")
            self.updateScreen()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateScreen() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.daysLabel.text = self.getDaysSinceStarted(self.challenge.createdDate)
        })
    }
    
    func getDaysSinceStarted(date: NSDate) -> String {
        let components: NSCalendarUnit = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitSecond | NSCalendarUnit.CalendarUnitMinute
        let date = NSCalendar.currentCalendar().components(components, fromDate: date, toDate: NSDate(), options: nil)
        return "\(date.day) days  \(date.hour) hours \(date.minute) minutes"
    }
}