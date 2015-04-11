//
//  ChallengeService.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 01/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation

struct ChallengeService {
    
    static func hasChallengeOnGoing() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey("challengeId") as? String
    }
    
    static func getMyChallenges(userId: String, successHandler: (challenge: [PFObject]) -> Void) {
        var query = PFQuery(className:"Challenge")
        
        query.whereKey("objectId", equalTo: userId)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println("Successfully retrieved \(objects.count) scores.")
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                    }
                    
                    successHandler(challenge: objects)
                }
            } else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }
    
    static func storeMyChallenge(successHandler: ((challenge: PFObject) -> Void)) {
        var challenge = PFObject(className: "Challenge")
        challenge.saveInBackgroundWithBlock ({ (success, error) -> Void in
            println("Challenge save")
            println("object id \(challenge.objectId)")

            if (success) {
                UserChallengeService.storeMyChallenge(challenge)
                successHandler(challenge: challenge)
            } else {
                println("Error storeMyChallenge")
            }
        })
    }
}
