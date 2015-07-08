import Foundation

class Enemy: PFObject {
    let type: Int
    
    init(type: Int) {
        self.type = type
        super.init()
    }
}