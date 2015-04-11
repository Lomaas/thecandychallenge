//
//  ContainerViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 31/03/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import UIKit

class ContainerViewController: UIPageViewController {
    var challenge: PFObject?
    lazy var _controllers : [UIViewController] = {
        let progressView = self.storyboard?.instantiateViewControllerWithIdentifier("progress") as ProgressViewController
        
        return [progressView]
        }()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "goToViewNotification:",
            name: "NavigateToNewView",
            object: nil)
        
        if (UserService.hasSignedUp()) {
            self.goToView(Constants.VIEWS.ProgressView.rawValue)
        } else {
            self.goToView(Constants.VIEWS.WelcomeView.rawValue)
        }
    }
    
    func goToViewNotification(notification: NSNotification) {
        let key = notification.userInfo?["key"] as Int
        goToView(key)
    }
    
    func goToView(key: Int) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        switch key {
        case Constants.VIEWS.InviteFriendsView.rawValue:
            let vc: InviteFriendsViewController = sb.instantiateViewControllerWithIdentifier("InviteFriends")
                as InviteFriendsViewController
            self.presentViewController(vc, animated: true, completion: nil)
        case Constants.VIEWS.ProgressView.rawValue:
            let vc: ProgressViewController = sb.instantiateViewControllerWithIdentifier("progress")
                as ProgressViewController
            self.presentViewController(vc, animated: false, completion: nil)
        case Constants.VIEWS.WelcomeView.rawValue:
            let vc = sb.instantiateViewControllerWithIdentifier("welcome") as WelcomeViewController
            self.presentViewController(vc, animated: true, completion: nil)
        default:
            println("No known key")
        }
    }
    
    func turnToPage(index: Int) {
        let controller = _controllers[index]
        
        var direction = UIPageViewControllerNavigationDirection.Forward
        
        if let currentViewController = viewControllers.first as? UIViewController {
            let currentIndex = (_controllers as NSArray).indexOfObject(currentViewController)
            
            if currentIndex > index {
                direction = UIPageViewControllerNavigationDirection.Reverse
            }
        }
        
        
        
        setViewControllers([controller],
            direction: direction,
            animated: true) { (completion) -> Void in
                
        }
    }
}
