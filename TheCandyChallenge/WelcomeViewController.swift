import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginFacebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToChooseEnemies" {
            let vc = segue.destinationViewController as! SelectEnemiesViewController
            vc.fromWelcomeView = true
            vc.challenge = sender as! Challenge
        }
    }
    
    func onProfileUpdated(notification: NSNotification) {
        println("OnprofileUpdated")
    }
    
    @IBAction func test(sender: AnyObject) {
        activityIndicator.startAnimating()
        loginFacebookButton.hidden = true
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"], block: { (user, error) -> Void in
            if (user != nil) {
                println("User logged in")
                self.returnUserData()
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
                let name = result.valueForKey("name") as? String ?? "No name"
                let email = result.valueForKey("email") as? String ?? "NoEmail@email.com"
                let fbId = result.valueForKey("id") as! String
                self.storeUserDataToServer(email, name: name, fbId: fbId)
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
        ChallengeService.sharedInstance.hasChallenge { (challenge) -> Void in
            if let challenge = challenge {
                self.performSegueWithIdentifier("goToChooseEnemies", sender: challenge)
            } else {
                let challenge = ChallengeService.sharedInstance.createChallenge()
                self.performSegueWithIdentifier("goToChooseEnemies", sender: challenge)
            }
        }        
    }
}

