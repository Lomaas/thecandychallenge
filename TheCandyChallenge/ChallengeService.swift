import Foundation


class ChallengeService {
    static let sharedInstance = ChallengeService()
    static let className = "Challenge"
    
    var challenge: Challenge! {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("NewDataAvailable", object: nil)
        }
    }
    
    init() {
        getMyChallengeFromLocalStorage()
    }
    
    func getMyChallenge() {
        getMyChallenge({ (userChallenge) -> Void in
            self.handler(userChallenge)
        }, errorHandler: { () -> Void in
                
        })
    }
    func findAndAddUsersToFriend(friendsIds: [String]) {
        let query = PFQuery(className: ChallengeService.className)
        query.whereKey("fbId", containedIn: friendsIds)
        query.findObjectsInBackgroundWithBlock({ (result, error) -> Void in            
            if error == nil {
                if let res = result {
                    self.getMyChallenge({ (userChallenge) -> Void in
                        userChallenge["friends"] = res
                        userChallenge.pinInBackground()
                        userChallenge.saveInBackground()
                        self.handler(userChallenge)
                    }, errorHandler: { () -> Void in
                        println("Error saving updated challenge")
                    })
                }
            } else {
                println("error fetching friends")
            }
        })
    }
    
    private func getMyChallenge(successHandler: (userChallenge: PFObject) -> Void, errorHandler: () -> Void) {
        var query = PFQuery(className: ChallengeService.className)
        
        if PFUser.currentUser() == nil {
            return
        }
        query.whereKey("fbId", equalTo: PFUser.currentUser()!.objectForKey("fbId")!)
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
    
    func getMyChallengeFromLocalStorage() {
        let query = PFQuery(className: ChallengeService.className)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil && objects?.count > 0 {
                if let userChallenge = objects!.first as? PFObject {
                    self.handler(userChallenge)
                }
            }
        })
    }
    
    func handler(userChallenge: PFObject) {
        userChallenge.pinInBackground()
        var friends = userChallenge["friends"] as! [PFObject]
        self.challenge = self.maptoChallengeModel(userChallenge)
        var returned = 0
        var friendsReturnArray = [PFObject]()
        
        for friend in friends {
            friend.fetchIfNeededInBackgroundWithBlock {
                (friend: PFObject?, error: NSError?) -> Void in
                returned++
                
                if let friend = friend {
                    let fbid = friend.objectForKey("fbId") as! String
                    friendsReturnArray.append(friend)
                    let parsedFriend = self.parseFriend(userChallenge)
                    self.challenge.friends.append(parsedFriend)
                    NSNotificationCenter.defaultCenter().postNotificationName("NewDataAvailable", object: nil)
                }
            }
        }
    }
    
    func hasChallenge(responseHandler: (challenge: Challenge?) -> Void) {
        self.getMyChallenge({ (userChallenge) -> Void in
            let challenge = self.maptoChallengeModel(userChallenge)
            userChallenge.pinInBackground()
            self.challenge = challenge
            responseHandler(challenge: challenge)
        }, errorHandler: { () -> Void in
            responseHandler(challenge: nil)
        })
    }
    
    func createChallenge() -> Challenge {
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
        
        return self.maptoChallengeModel(userChallenge)
    }
    
    func updateChallengeWithEnemies(challenge: Challenge) {
        self.getMyChallenge({ (userChallenge) -> Void in
            userChallenge["enemies"] = self.parseEnemiesToJson(challenge)
            userChallenge.pinInBackground()
            userChallenge.saveInBackground()
            self.handler(userChallenge)
        }, errorHandler: { () -> Void in
            
        })
    }
    
    private func maptoChallengeModel(challenge: PFObject) -> Challenge {
        let createdDate = challenge.createdAt == nil ? NSDate() : challenge.createdAt!
        let enemies = self.parseEnemies(challenge["enemies"] as! [AnyObject])
        let name = challenge["name"] as! String
        return Challenge(name: name, createdDate: createdDate, enemies: enemies, friends: [Friend]())
    }
    
    private func parseEnemies(input : [AnyObject]) -> [Enemy] {
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
    
    private func parseEnemiesToJson(challenge: Challenge) -> [[String : AnyObject]] {
        return challenge.enemies.map({ (enemy) -> [String : AnyObject] in
            return ["date" : enemy.date, "type" : enemy.type, "amount" : enemy.amount]
        })
    }
    
    private func parseFriend(userChallenge: PFObject) -> Friend {
        let challenge = maptoChallengeModel(userChallenge)
        let date = challenge.createdDate
        let mainEnemy = challenge.findMainEnemy() != nil ?
            challenge.findMainEnemy()!.fromTypeToString() : "None"
        let id = userChallenge["fbId"] as! String
        return Friend(id: id, name: challenge.name, startDate: date, mainEnemy: mainEnemy)
    }
}