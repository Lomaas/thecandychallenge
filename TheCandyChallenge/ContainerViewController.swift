//
//  ContainerViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 31/03/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    var controllers : [UIViewController] = [];
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!UserService.isLoggedIn()) {
            goToView(Constants.VIEWS.ProgressView.rawValue)
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "goToViewNotification:",
            name: "NavigateToNewView",
            object: nil)
    }
    
    func goToViewNotification(notification: NSNotification) {
        let key = notification.userInfo?["key"] as Int
        goToView(key)
    }
    
    func goToView(key: Int) {
        switch key {
        case Constants.VIEWS.InviteFriendsView.rawValue:
            println("welcomeview")
            var vc: InviteFriendsViewController = UIStoryboard().instantiateViewControllerWithIdentifier("InviteFriends")
                as InviteFriendsViewController
            
            UINavigationController().presentViewController(vc, animated: true, completion: nil)
        case Constants.VIEWS.ProgressView.rawValue:
            var vc: InviteFriendsViewController = UIStoryboard().instantiateViewControllerWithIdentifier("InviteFriends")
                as InviteFriendsViewController
            
            UINavigationController().presentViewController(vc, animated: true, completion: nil)
            
        default:
            println("No known key")
        }
    }
}
