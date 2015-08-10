import Foundation

@objc
class Challenge: NSObject, NSCoding {
    static let key = "challenge1"
    
    let name: String
    var createdDate: NSDate
    var enemies: [Enemy]
    var daysMissedInRow: Int
    
    init(name: String, createdDate: NSDate, enemies: [Enemy], daysMissedInRow: Int) {
        self.name = name
        self.createdDate = createdDate
        self.enemies = enemies
        self.daysMissedInRow = daysMissedInRow
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
        self.daysMissedInRow = aDecoder.decodeObjectForKey("daysMissedInRow") as? Int == nil ?
            0 : aDecoder.decodeObjectForKey("daysMissedInRow") as! Int
    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(self.name, forKey: "name")
        _aCoder.encodeObject(self.createdDate, forKey: "createdDate")
        _aCoder.encodeObject(self.enemies, forKey: "enemies")
        _aCoder.encodeObject(self.daysMissedInRow, forKey: "daysMissedInRow")
    }
        
    func findMainEnemy() -> Enemy? {
        enemies.sort { $0.amount > $1.amount }
        return enemies.first!
    }
    
    func isForfeinted() -> Bool {
        return daysMissedInRow > 1
    }
}