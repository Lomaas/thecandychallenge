import Foundation


class ChallengeService {
    static let sharedInstance = ChallengeService()
    static let className = "Challenge"

    private var tempFriends: [Friend]!
    

    init() {

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

    func handler(userChallenge: PFObject) {
        var friends = userChallenge["friends"] as! [PFObject]
        let challenge = self.maptoChallengeModel(userChallenge)
        challenge.save()
        self.tempFriends = [Friend]()
        
        var returned = 0
        
        for friend in friends {
            friend.fetchIfNeededInBackgroundWithBlock {
                (friend: PFObject?, error: NSError?) -> Void in
                returned++
                
                if let friend = friend {
                    self.tempFriends.append(self.parseFriend(friend))
                    
                    if returned == friends.count {
                        println("Returned is equal friends count")
                        let saveFriends = Friends(friends: self.tempFriends)
                        saveFriends.save()
                        NSNotificationCenter.defaultCenter().postNotificationName("FriendsFetched", object: nil)
                    }
                }
            }
        }
    }
    
    func hasChallenge(responseHandler: (challenge: Challenge?) -> Void) {
        self.getMyChallenge({ (userChallenge) -> Void in
            let challenge = self.maptoChallengeModel(userChallenge)
            challenge.save()
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
        userChallenge["daysMissedInRow"] = 0

        userChallenge.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                println("user challenged saved")
            }
            if let error = error {
                println("Error: \(error) \(error.userInfo)")
            }
        }
        let challenge = self.maptoChallengeModel(userChallenge)
        challenge.save()
        return challenge
    }
    
    func updateChallenge(challenge: Challenge) {
        challenge.save()
        
        self.getMyChallenge({ (userChallenge) -> Void in
            userChallenge["enemies"] = self.parseEnemiesToJson(challenge)
            userChallenge["daysMissedInRow"] = challenge.daysMissedInRow
            userChallenge.saveInBackground()
            self.handler(userChallenge)
        }, errorHandler: { () -> Void in
            
        })
    }
    
    private func maptoChallengeModel(challenge: PFObject) -> Challenge {
        let createdDate = challenge.createdAt == nil ? NSDate() : challenge.createdAt!
        let enemies = self.parseEnemies(challenge["enemies"] as! [AnyObject])
        let name = challenge["name"] as! String
        let daysMissedInRow = challenge["daysMissedInRow"] as! Int
        return Challenge(name: name, createdDate: createdDate, enemies: enemies, daysMissedInRow: daysMissedInRow)
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
        return Friend(id: id, name: challenge.name, startDate: date, mainEnemy: mainEnemy, isForfeinted: challenge.isForfeinted())
    }
}