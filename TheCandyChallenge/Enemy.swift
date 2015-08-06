import Foundation

enum Enemies: Int {
    case normalCandy = 1
    case chocklade = 2
    case soda = 3
}

@objc
class Enemy: NSObject, Printable, NSCoding {
    static let key = "Enemy"
    
    let type: Int
    let date: NSDate
    var amount: Int {
        didSet {
            if amount < 0 {
                amount = 0
            }
        }
    }
    
    var price: Int {
        return amount * self.getPriceForUnit()
    }
    
    override var description: String {
        return "\(type), date: \(date), amount: \(amount)"
    }
    
    init(type: Int, date: NSDate, amount: Int) {
        self.type = type
        self.date = date
        self.amount = amount
    }
    
    func save() {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(encodedObject, forKey: Enemy.key)
    }
    
    static func get() -> Enemy? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let encodedObject = defaults.objectForKey(Enemy.key) as? NSData
        var enemy: Enemy?
        
        if let encodedObject = encodedObject {
            enemy = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as? Enemy
        }
        
        return enemy;
    }
    
    // MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.type = aDecoder.decodeObjectForKey("type") as! Int
        self.date = aDecoder.decodeObjectForKey("date") as! NSDate
        self.amount = aDecoder.decodeObjectForKey("amount") as! Int
    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(self.type, forKey: "type")
        _aCoder.encodeObject(self.date, forKey: "date")
        _aCoder.encodeObject(self.amount, forKey: "amount")
    }
    
    func fromTypeToString() -> String {
        switch type {
        case Enemies.chocklade.rawValue:
            return "Chockolade"
        case Enemies.soda.rawValue:
            return "Soda"
        default:
            println("enemy not mapped out")
            return "None"
        }
    }
    
    func getPriceForUnit() -> Int {
        switch type {
        case Enemies.chocklade.rawValue:
            return 30
        case Enemies.soda.rawValue:
            return 18
        default:
            println("enemy not mapped out")
            return 0
        }
    }
}