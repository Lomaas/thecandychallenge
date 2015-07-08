//
//  ViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 25/03/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)
    }
    
    func onProfileUpdated(notification: NSNotification) {
        print("OnprofileUpdated")
    }
    
    @IBAction func test(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"], block: { (user, error) -> Void in
            if (user != nil) {
                if (user!.isNew) {
                    print("User signed up")
                    self.returnUserData()
                } else {
                    print("User logged in")
                    self.returnUserData()
                }
            }
        })
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                print("Error: \(error)")
            } else {
                print("fetched user: \(result)")
                let name : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(name)")
                let email = result.valueForKey("email") as! String
                let fbId : String = result.valueForKey("id") as! String
                self.storeUserDataToServer(email, name: name as String, fbId: fbId)
                print("User Email is: \(email)")
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
                print("success")
                self.finishedUserSetup()
            } else {
                print("problems")
            }
        })
    }
    
    func finishedUserSetup() {
        ChallengeService.createChallenge()
        self.performSegueWithIdentifier("goToProgressView", sender: nil)
    }
}

