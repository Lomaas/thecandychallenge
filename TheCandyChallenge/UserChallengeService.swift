//
//  UserChallengeService.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 01/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

struct UserChallengeService {
    static func getMyChallenge(successHandler: (userChallenge: PFObject) -> Void) {
        var query = PFQuery(className:"UserChallenge")
        
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                println("Successfully retrieved \(objects!.count) UserChallenges.")
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                    }
                    if objects.count > 0 {
                        successHandler(userChallenge: objects[0] as PFObject)
                    }
                }
            } else {
                println("Error: \(error!) \(error!.userInfo!)")
            }
        })
    }
    
    static func storeMyChallenge(challenge: PFObject) {
        var userChallenge = PFObject(className: "UserChallenge")
        userChallenge["date"] = NSDate()
        userChallenge["challenge"] = challenge
        userChallenge["user"] = PFUser.currentUser()

        userChallenge["calories"] = 0
        userChallenge["moneySaved"] = 0
        userChallenge.pinInBackground()
        userChallenge.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                println("user challenged saved")
                
            }
            if let error = error {
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }
    
    static func getMyChallengeFromLocalStorage(succesHandler: (userChallenge: PFObject) -> Void, errorHandler: () -> Void) {
        let query = PFQuery(className:"UserChallenge")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                if objects?.count == 0 {
                    errorHandler()
                } else {
                    if let userChallenge = objects!.first as? PFObject {
                        succesHandler(userChallenge: userChallenge)
                    }
                }
            }
        })
    }
}