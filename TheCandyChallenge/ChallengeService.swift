import Foundation


struct ChallengeService {
    static let className = "Challenge"
    
    static func findAndAddUsersToFriend(friendsIds: [String]) {
        let query = PFQuery(className: ChallengeService.className)
        query.whereKey("fbId", containedIn: friendsIds)
        
        query.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
            println("Result: \(result), error: \(error)")
            
            if error == nil {
                if let res = result {
                    ChallengeService.getMyChallengeFromLocalStorage({ (userChallenge) -> Void in
                        userChallenge["friends"] = res
                        userChallenge.saveInBackground()
                        }, errorHandler: { () -> Void in
                            println("Error saving updated challenge")
                    })
                }
            } else {
                print("error fetching friends")
            }
        })
    }
    
    private static func getMyChallenge(successHandler: (userChallenge: PFObject) -> Void, errorHandler: () -> Void) {
        var query = PFQuery(className: ChallengeService.className)
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                println("Successfully retrieved \(objects!.count) Challenges.")
                
                if let objects = objects as? [PFObject] {
                    if objects.count > 0 {
                        successHandler(userChallenge: objects[0] as PFObject)
                    } else {
                        errorHandler()
                    }
                }
            } else {
                println("Error: \(error!) \(error!.userInfo)")
                errorHandler()
            }
        })
    }
    
    static func createChallenge() -> Challenge {
        let userChallenge = PFObject(className: ChallengeService.className)
        userChallenge["date"] = NSDate()
        userChallenge["user"] = PFUser.currentUser()
        userChallenge["fbId"] = PFUser.currentUser()?.objectForKey("fbId")
        userChallenge["enemies"] = []
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
        
        return ChallengeService.maptoChallengeModel(userChallenge)
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
    
    static func getMyChallenge(responseHandler: (userChallenge: Challenge) -> Void) {
        ChallengeService.getMyChallengeFromLocalStorage({ (userChallenge: PFObject) -> Void in
            responseHandler(userChallenge: ChallengeService.maptoChallengeModel(userChallenge))
        }, errorHandler: { () -> Void in
            
            ChallengeService.getMyChallenge({ (userChallenge) -> Void in
                responseHandler(userChallenge: ChallengeService.maptoChallengeModel(userChallenge))
            }, errorHandler: { () -> Void in
                responseHandler(userChallenge: ChallengeService.createChallenge())
            })
        })
    }
    
    static func updateChallenge(challenge: Challenge) {
        ChallengeService.getMyChallengeFromLocalStorage({ (userChallenge) -> Void in
            userChallenge["enemies"] = ChallengeService.parseEnemiesToJson(challenge)
            userChallenge["friends"] = challenge.friends
            userChallenge.pinInBackground()
            userChallenge.saveInBackground()
        }, errorHandler: { () -> Void in
            println("Error saving updated challenge")
        })
    }
    
    private static func maptoChallengeModel(challenge: PFObject) -> Challenge {
        let createdDate = challenge.createdAt == nil ? NSDate() : challenge.createdAt!
        let enemies = ChallengeService.parseEnemies(challenge["enemies"] as! [AnyObject])
        let friends = ChallengeService.parseFriends(challenge["friends"] as! [PFObject])
        let name = (challenge["user"] as! PFUser).objectForKey("name") as! String
        return Challenge(name: name, createdDate: createdDate, enemies: enemies, friends: friends)
    }
    
    private static func parseEnemies(input : [AnyObject]) -> [Enemy] {
        if let enemies = input as? [[String : AnyObject]] {
            var returnEnemies = [Enemy]()
            for enemy in enemies {
                let type = enemy["type"] as! Int
                let date = enemy["date"] as! NSDate
                let amount = enemy["amount"] as! Int
                returnEnemies.append(Enemy(type: type, date: date, amount: amount))
            }
            
            return returnEnemies
        }
        return [Enemy(type: 2, date: NSDate(), amount: 3)]
    }
    
    private static func parseEnemiesToJson(challenge: Challenge) -> [[String : AnyObject]] {
        return challenge.enemies.map({ (enemy) -> [String : AnyObject] in
            return ["date" : enemy.date, "type" : enemy.type, "amount" : enemy.amount]
        })
    }
    
    private static func parseFriends(challenges: [PFObject]) -> [Friend] {
        var friends = [Friend]()
        
        for pfChallenge in challenges {
            let challenge = maptoChallengeModel(pfChallenge)
            let date = challenge.createdDate
            let mainEnemy = challenge.findMainEnemy().fromTypeToString()
            
            friends.append(Friend(name: challenge.name, startDate: date, mainEnemy: mainEnemy))
        }
        
        
        return friends
    }
    
    private static func parseFriendsToJson(challenge: Challenge) -> [[String : AnyObject]] {
        return challenge.friends.map({ (friend) -> [String : AnyObject] in
            return ["fbId" : "ksjafklsdj"]
        })
    }
}