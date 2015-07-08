//
//  UserChallengeService.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 01/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//
import Foundation

struct ChallengeService {
    static let className = "Challenge"
    
    private static func getMyChallenge(successHandler: (userChallenge: PFObject) -> Void, errorHandler: () -> Void) {
        var query = PFQuery(className: ChallengeService.className)
        
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                print("Successfully retrieved \(objects!.count) Challenges.")
                
                if let objects = objects as? [PFObject] {
                    if objects.count > 0 {
                        successHandler(userChallenge: objects[0] as PFObject)
                    } else {
                        errorHandler()
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                errorHandler()
            }
        })
    }
    
    static func createChallenge() -> PFObject {
        var userChallenge = PFObject(className: ChallengeService.className)
        userChallenge["date"] = NSDate()
        userChallenge["user"] = PFUser.currentUser()
        userChallenge["enemies"] = [["type" : 1, "date": NSDate()]]
        userChallenge["friends"] = []
        userChallenge.pinInBackground()
        userChallenge.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                println("user challenged saved")
            }
            if let error = error {
                println("Error: \(error) \(error.userInfo)")
            }
        }
        return userChallenge
    }
    
    private static func getMyChallengeFromLocalStorage(succesHandler: (userChallenge: PFObject) -> Void, errorHandler: () -> Void) {
        let query = PFQuery(className: ChallengeService.className)
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
    
    static func getMyChallenge(responseHandler: (userChallenge: PFObject) -> Void) {
        ChallengeService.getMyChallengeFromLocalStorage({ (userChallenge: PFObject) -> Void in
            responseHandler(userChallenge: userChallenge)
        }, errorHandler: { () -> Void in
            ChallengeService.getMyChallenge(responseHandler, errorHandler: { () -> Void in
                responseHandler(userChallenge: ChallengeService.createChallenge())
            })
        })
    }
}