import Foundation
import UIKit
import HealthKit
import Charts

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
    
    @IBOutlet weak var pieChartView: PieChartView!
    var challenge: Challenge!
    var itemIndex: Int = 1
    var dataArray = [Friend]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pieChartView.noDataText = "NoData :("
        pieChartView.delegate = self

//        pieChartView.usePercentValuesEnabled = true
        pieChartView.holeTransparent = true
        pieChartView.holeRadiusPercent = 0.58
//        pieChartView.transparentCircleRadiusPercent = 0.5
        pieChartView.descriptionText = "Summary"
        pieChartView.drawCenterTextEnabled = true
//        pieChartView.drawHoleEnabled = true
        pieChartView.centerTextColor = UIColor.blueColor()
        pieChartView.centerTextFont = UIFont(name: "Avenir Next", size: 20)!
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getData:", name: "NewDataAvailable", object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let challenge = challenge {
            updateScreen()
        }
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
        challenge = ChallengeService.sharedInstance.challenge
        print("Has challenge with createdDate: \(challenge.createdDate)")
        updateScreen()
    }
    
    func updateScreen() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            
            self.setChart(
                self.challenge.enemies.map() { return $0.fromTypeToString() },
                values: self.challenge.enemies.map() { return Double($0.price) }
            )
            
            self.pieChartView.centerText = self.getTimeSinceStarted(self.challenge.createdDate)
            self.view.setNeedsLayout()
        })
    }
    
    func getTimeSinceStarted(date: NSDate) -> String {
        let components: NSCalendarUnit = NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitSecond | NSCalendarUnit.CalendarUnitMinute
        let date = NSCalendar.currentCalendar().components(components, fromDate: date, toDate: NSDate(), options: nil)
        return "\(date.day)d \(date.hour)h \(date.minute)m"
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Kroner")
        pieChartDataSet.sliceSpace = 5
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData

        pieChartDataSet.colors = [UIColor(red: 144/255, green: 235/255, blue: 255/255, alpha: 1), UIColor(red: 254/255, green: 209/255, blue: 145/255, alpha: 1)]
        
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

extension ProgressViewController: ChartViewDelegate {
    
}