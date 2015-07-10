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
    let friendTableViewCellIdentifier = "FriendTableViewCell"
    
    var challenge: Challenge!
    var itemIndex: Int = 1
    var dataArray = [Friend]()

    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getData:", name: "NewDataAvailable", object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // fix go to enemies bug
        if segue.identifier == "goToEnemies" {
            let vc = segue.destinationViewController as! SelectEnemiesViewController
            vc.challenge = challenge
        } else if segue.identifier == "goToInviteFriends" {
            let vc = segue.destinationViewController as! InviteFriendsViewController
            vc.challenge = challenge
        }
    }
    
    func getData(notification: NSNotification) {
        getData()
    }
    
    func getData() {
        ChallengeService.getMyChallenge({ (userChallenge: Challenge) -> Void in
            self.challenge = userChallenge
            self.dataArray = userChallenge.friends
            print("Has challenge with createdDate: \(self.challenge.createdDate)")
            self.updateScreen()
        })
    }
    
    func updateScreen() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.daysLabel.text = self.getTimeSinceStarted(self.challenge.createdDate)
            self.tableView.reloadData()
        })
    }
    
    func getTimeSinceStarted(date: NSDate) -> String {
        let components: NSCalendarUnit = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitSecond | NSCalendarUnit.CalendarUnitMinute
        let date = NSCalendar.currentCalendar().components(components, fromDate: date, toDate: NSDate(), options: nil)
        return "\(date.day) days \(date.hour) hours \(date.minute) minutes"
    }
}

extension ProgressViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(friendTableViewCellIdentifier, forIndexPath: indexPath) as! FriendTableViewCell
        cell.nameLabel.text = dataArray[indexPath.row].name
        cell.timeWithout.text = getTimeSinceStarted(dataArray[indexPath.row].startDate)
        cell.mainEnemyLabel.text = "Main enemy: \(dataArray[indexPath.row].mainEnemy)"

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}