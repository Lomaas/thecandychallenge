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
        println("OnprofileUpdated")
        
    }
    
    @IBAction func test(sender: AnyObject) {
//        returnUserData()
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"], block: { (user, error) -> Void in
            if (user != nil) {
                if (user.isNew) {
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
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let name : NSString = result.valueForKey("name") as NSString
                println("User Name is: \(name)")
                let email : NSString = result.valueForKey("email") as NSString
                let fbId : String = result.valueForKey("id") as String
                self.storeUserDataToServer(email, name: name, fbId: fbId)
                println("User Email is: \(email)")
            }
        })
    }
    
    func storeUserDataToServer(email: String, name: String, fbId: String) {
        var user:PFUser = PFUser.currentUser()
        user["email"] = email
        user["name"] = name
        user["fbId"] = fbId
        
        user.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                println("success")
                self.userAlreadyRegister()
            } else {
                println("problems")
            }
        })
    }
    
    func userAlreadyRegister() {
        NSNotificationCenter.defaultCenter().postNotificationName("NavigateToNewView", object:nil, userInfo:["key" : Constants.VIEWS.InviteFriendsView.rawValue])

    }
}

