import Foundation

class Friend {
    let name: String
    let startDate: NSDate
    let mainEnemy: String
    
    init(name: String, startDate: NSDate, mainEnemy: String) {
        self.name = name
        self.startDate = startDate
        self.mainEnemy = mainEnemy
    }
}