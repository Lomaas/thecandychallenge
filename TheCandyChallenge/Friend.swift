import Foundation

class Friend {
    let id: String
    let name: String
    let startDate: NSDate
    let mainEnemy: String
    
    init(id: String, name: String, startDate: NSDate, mainEnemy: String) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.mainEnemy = mainEnemy
    }
}