import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)
    }
    
    func onProfileUpdated(notification: NSNotification) {
        println("OnprofileUpdated")
    }
    
    @IBAction func test(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"], block: { (user, error) -> Void in
            if (user != nil) {
                if (user!.isNew) {
                    println("User signed up")
                    self.returnUserData()
                } else {
                    println("User logged in")
                    self.returnUserData()
                }
            }
        })
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                println("Error: \(error)")
            } else {
                println("fetched user: \(result)")
                let name : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(name)")
                let email = result.valueForKey("email") as! String
                let fbId : String = result.valueForKey("id") as! String
                self.storeUserDataToServer(email, name: name as String, fbId: fbId)
                println("User Email is: \(email)")
            }
        })
    }
    
    func storeUserDataToServer(email: String, name: String, fbId: String) {
        let user:PFUser = PFUser.currentUser()!
        user["email"] = email
        user["name"] = name
        user["fbId"] = fbId
        
        user.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                println("success")
                self.finishedUserSetup()
            } else {
                println("problems")
            }
        })
    }
    
    func finishedUserSetup() {
        ChallengeService.createChallenge()
        self.performSegueWithIdentifier("goToInviteFriends", sender: nil)
    }
}

