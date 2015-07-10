import Foundation


struct ChallengeService {
    static let className = "Challenge"
    
    static func findAndAddUsersToFriend(friendsIds: [String]) {
        let query = PFQuery(className: ChallengeService.className)
        query.whereKey("fbId", containedIn: friendsIds)
        
        query.findObjectsInBackgroundWithBlock({ (result, error) -> Void in            
            if error == nil {
                if let res = result {
                    ChallengeService.getMyChallengeFromLocalStorage({ (userChallenge) -> Void in
                        userChallenge["friends"] = res
                        userChallenge.pinInBackground()
                        userChallenge.saveInBackground()
                        NSNotificationCenter.defaultCenter().postNotificationName("NewDataAvailable", object: nil)

                    }, errorHandler: { () -> Void in
                            println("Error saving updated challenge")
                    })
                }
            } else {
                println("error fetching friends")
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
        userChallenge["userObjectId"] = PFUser.currentUser()?.objectId
        userChallenge["name"] = PFUser.currentUser()?.objectForKey("name")
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
        
        return ChallengeService.maptoChallengeModel(userChallenge, friends: nil)
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
        func handler(userChallenge: PFObject) {
            var friends = userChallenge["friends"] as! [PFObject]
            if friends.count == 0 {
                responseHandler(userChallenge: ChallengeService.maptoChallengeModel(userChallenge, friends: nil))
                return
            }
            var returned = 0
            var friendsReturnArray = [PFObject]()
            for friend in friends {
                friend.fetchIfNeededInBackgroundWithBlock {
                    (friend: PFObject?, error: NSError?) -> Void in
                    
                    let fbid = friend?.objectForKey("fbId") as! String
                    returned++
                    friendsReturnArray.append(friend!)
                    if returned == friends.count {
                        responseHandler(userChallenge: ChallengeService.maptoChallengeModel(userChallenge, friends: friendsReturnArray))
                    }
                }
            }
        }
        
        ChallengeService.getMyChallengeFromLocalStorage(handler, errorHandler: { () -> Void in
            ChallengeService.getMyChallenge({ (userChallenge) -> Void in
                var friends = userChallenge["friends"] as! [PFObject]
                if friends.count == 0 {
                    responseHandler(userChallenge: ChallengeService.maptoChallengeModel(userChallenge, friends: nil))
                    return
                }
                for friend in friends {
                    friend.fetchIfNeededInBackgroundWithBlock {
                        (friend: PFObject?, error: NSError?) -> Void in
                        let fbid = friend?.objectForKey("fbId") as! String
                        println("\(fbid)")
                        responseHandler(userChallenge: ChallengeService.maptoChallengeModel(userChallenge, friends: [friend!]))
                    }
                }
            }, errorHandler: { () -> Void in
                responseHandler(userChallenge: ChallengeService.createChallenge())
            })
        })
    }
    
    static func updateChallengeWithEnemies(challenge: Challenge) {
        ChallengeService.getMyChallengeFromLocalStorage({ (userChallenge) -> Void in
            userChallenge["enemies"] = ChallengeService.parseEnemiesToJson(challenge)
            userChallenge.pinInBackground()
            userChallenge.saveInBackground()
        }, errorHandler: { () -> Void in
            println("Error saving updated challenge")
        })
    }
    
    private static func maptoChallengeModel(challenge: PFObject, friends: [PFObject]?) -> Challenge {
        let createdDate = challenge.createdAt == nil ? NSDate() : challenge.createdAt!
        let enemies = ChallengeService.parseEnemies(challenge["enemies"] as! [AnyObject])
        let friends = friends != nil ? ChallengeService.parseFriends(friends!) : [Friend]()
        let name = challenge["name"] as! String
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
            let challenge = maptoChallengeModel(pfChallenge, friends: nil)
            let date = challenge.createdDate
            let mainEnemy = challenge.findMainEnemy().fromTypeToString()
            let id = pfChallenge["fbId"] as! String
            friends.append(Friend(id: id, name: challenge.name, startDate: date, mainEnemy: mainEnemy))
        }
        
        
        return friends
    }
}