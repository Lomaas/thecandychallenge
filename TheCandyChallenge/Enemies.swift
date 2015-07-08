import Foundation

class Enemies: PFObject {
    let enemies: [Enemy]
    
    init(enemies: [Enemy]) {
        self.enemies = enemies
        super.init()
    }
}