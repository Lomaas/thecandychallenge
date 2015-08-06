import Foundation

class Challenge {
    let name: String
    let createdDate: NSDate
    var enemies: [Enemy]
    var friends: [Friend]
    
    init(name: String, createdDate: NSDate, enemies: [Enemy], friends: [Friend]) {
        self.name = name
        self.createdDate = createdDate
        self.enemies = enemies
        self.friends = friends
    }
    
    func findMainEnemy() -> Enemy? {
        enemies.sort { $0.amount > $1.amount }
        return enemies.first!
    }
}