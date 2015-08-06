//
//  Friends.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 06/08/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation

@objc
class Friends: NSObject, NSCoding {
    static let key = "Friends"
    let friends: [Friend]
    
    init(friends: [Friend]) {
        self.friends = friends
    }
    
    func save() {
        let encodedObject = NSKeyedArchiver.archivedDataWithRootObject(self)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(encodedObject, forKey: Friends.key)
    }
    
    static func get() -> Friends? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let encodedObject = defaults.objectForKey(Friends.key) as? NSData
        var friends: Friends?
        
        if let encodedObject = encodedObject {
            friends = NSKeyedUnarchiver.unarchiveObjectWithData(encodedObject) as? Friends
        }
        
        return friends;
    }
    
    // MARK: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        self.friends = aDecoder.decodeObjectForKey("friends") as! [Friend]
    }
    
    func encodeWithCoder(_aCoder: NSCoder) {
        _aCoder.encodeObject(self.friends, forKey: "friends")
    }
}