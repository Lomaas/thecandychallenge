import Foundation


let notificationCategoryIdent  = "ACTIONABLE";
let notificationActionOneIdent = "noCandy";
let notificationActionTwoIdent = "iFailed";

@objc
class Notification: NSObject, NSCoding {
    static let key = "notification"
    var earlyDay: Bool
    var lateDay: Bool
    
    init (earlyDay: Bool = false, lateDay: Bool = false) {
        self.earlyDay = earlyDay
        self.lateDay = lateDay
        super.init()
       }
    
    func save() {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(encodedObject, forKey: Notification.key)
    }
    
    static func get() -> Notification? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let encodedObject = defaults.objectForKey(Notification.key) as? NSData
        var challenge: Notification?
        
        if let encodedObject = encodedObject {
            challenge = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as? Notification
        }
        return challenge;
    }
    
    // MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        if let earlyDay = aDecoder.decodeObjectForKey("earlyDay") as? Bool {
            self.earlyDay = earlyDay
        } else {
            self.earlyDay = false
        }
        if let lateDay = aDecoder.decodeObjectForKey("lateDay") as? Bool {
            self.lateDay = lateDay
        } else {
            self.lateDay = false
        }
    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(self.earlyDay, forKey: "earlyday")
        _aCoder.encodeObject(self.lateDay, forKey: "lateDay")
    }
    
    func updateSchedule(category: String, identifier: String) {
        
    }
    
    func sethasScheduledEarlyDayNotifcation() {
        self.earlyDay = true
    }
    
    func sethasScheduledLateDayNotification() {
        self.lateDay = true
    }
    
    
    func hasScheduledEarlyDayNotifcation() -> Bool {
        return earlyDay
    }
    
    func hasScheduledLateDayNotification() -> Bool {
        return lateDay
    }
    
    func reset() {
        Notification().save()
    }
}