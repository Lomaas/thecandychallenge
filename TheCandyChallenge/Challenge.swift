import Foundation

@objc
class Challenge: NSObject, NSCoding {
    static let key = "challenge1"
    
    let name: String
    let createdDate: NSDate
    var enemies: [Enemy]
    
    init(name: String, createdDate: NSDate, enemies: [Enemy]) {
        self.name = name
        self.createdDate = createdDate
        self.enemies = enemies
    }
    
    func save() {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(encodedObject, forKey: Challenge.key)
    }
    
    static func get() -> Challenge? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let encodedObject = defaults.objectForKey(Challenge.key) as? NSData
        var challenge: Challenge?
        
        if let encodedObject = encodedObject {
            challenge = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as? Challenge
        }
        return challenge;
    }
    
    // MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.createdDate = aDecoder.decodeObjectForKey("createdDate") as! NSDate
        self.enemies = aDecoder.decodeObjectForKey("enemies") as! [Enemy]
    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(self.name, forKey: "name")
        _aCoder.encodeObject(self.createdDate, forKey: "createdDate")
        _aCoder.encodeObject(self.enemies, forKey: "enemies")
    }
        
    func findMainEnemy() -> Enemy? {
        enemies.sort { $0.amount > $1.amount }
        return enemies.first!
    }
}