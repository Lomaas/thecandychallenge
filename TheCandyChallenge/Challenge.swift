import Foundation

class Challenge {
    let createdDate: NSDate
    var enemies: [Enemy]
    var friends: [Friend]
//    let user: User
    
    init(createdDate: NSDate, enemies: [Enemy], friends: [Friend]) {
        self.createdDate = createdDate
        self.enemies = enemies
        self.friends = friends
//        self.user = user
    }
}