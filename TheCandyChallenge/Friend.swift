import Foundation

@objc
class Friend: NSObject, NSCoding {
    static let key = "Friend"
    
    let id: String
    let name: String
    let startDate: NSDate
    let mainEnemy: String
    let isForfeinted: Bool
    
    init(id: String, name: String, startDate: NSDate, mainEnemy: String, isForfeinted: Bool) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.mainEnemy = mainEnemy
        self.isForfeinted = isForfeinted
    }
    
    func save() {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(encodedObject, forKey: Friend.key)
    }
    
    static func get() -> Friend? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let encodedObject = defaults.objectForKey(Friend.key) as? NSData
        var friend: Friend?
        
        if let encodedObject = encodedObject {
            friend = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as? Friend
        }
        
        return friend;
    }
    
    // MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObjectForKey("id") as! String
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.startDate = aDecoder.decodeObjectForKey("startDate") as! NSDate
        self.mainEnemy = aDecoder.decodeObjectForKey("mainEnemy") as! String
        if let isForfeinted = aDecoder.decodeObjectForKey("isForfeinted") as? Bool {
            self.isForfeinted = isForfeinted
        } else {
            self.isForfeinted = false
        }
    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(self.id, forKey: "id")
        _aCoder.encodeObject(self.name, forKey: "name")
        _aCoder.encodeObject(self.startDate, forKey: "startDate")
        _aCoder.encodeObject(self.mainEnemy, forKey: "mainEnemy")
        _aCoder.encodeObject(self.isForfeinted, forKey: "isForfeinted")
    }
}