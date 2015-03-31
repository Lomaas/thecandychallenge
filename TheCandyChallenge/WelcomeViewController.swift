//
//  ViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 25/03/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            self.userAlreadyRegister()
            return
        }
        
        fbLoginButton.delegate = self;
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        self.fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)
    }
    
    func onProfileUpdated(notification: NSNotification) {
        println("OnprofileUpdated")
        
    }
    
    @IBAction func test(sender: AnyObject) {
        returnUserData()
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.containsObject("email") {
                self.returnUserData()
            }
            else {
                var alert = UIAlertController(title: "Ups", message: "The application needs the email in order to work. You can register normally below", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Login again?", style: UIAlertActionStyle.Default, handler: { action in
                        // Send user back to facebook
                }))
                self.presentViewController(alert, animated: true, completion:nil)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("did logout")
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
        var user:PFUser = PFUser()
        user["email"] = email
        user["name"] = name
        user["fbId"] = fbId
        user.username = email
        user.password = NSUUID().UUIDString
        
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if let error = error {
                println("Error \(error.localizedDescription), \(error.code)")
                
                switch error.code {
                case 202:
                    println("202")
                    self.userAlreadyRegister()
                default:
                    println("NOT DEFAUlt CASE")
                }
            }
            
            if success {
                println("success")
            } else {
                println("problems")
            }
        }
    }
    
    func userAlreadyRegister() {
        
    }
}

