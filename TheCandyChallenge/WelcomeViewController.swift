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
            
        }
        
        fbLoginButton.delegate = self;
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onProfileUpdated:", name:FBSDKProfileDidChangeNotification, object: nil)
        
    }
    
    func onProfileUpdated(notification: NSNotification) {
        println("OnprofileUpdated")
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        println("loginButton")
   
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("did logout")

    }

}

