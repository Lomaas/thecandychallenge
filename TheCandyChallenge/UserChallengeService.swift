//
//  UserChallengeService.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 01/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

struct UserChallengeService {
    func getMyChallenges(successHandler: (challenge: [PFObject]) -> Void) {
        var query = PFQuery(className:"UserChallenge")
        
        query.whereKey("user", equalTo: PFUser.currentUser())
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
    
    func storeMyChallenge() {
        var challenge = PFObject(className: "UserChallenge")
        challenge["user"] = PFUser.currentUser()
        challenge["date"] = NSDate()
    }
}