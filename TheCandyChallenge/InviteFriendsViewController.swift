//
//  InviteFriendsViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 31/03/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation
import UIKit

class InviteFriendsViewController: UIViewController, UITextFieldDelegate {
    var challenge: PFObject?
    
    @IBOutlet weak var searchField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        ChallengeService.storeMyChallenge { (challenge: PFObject) -> Void in
            self.challenge = challenge
            self.performSegueWithIdentifier("goToProgressView", sender: sender)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let progressViewController = segue.destinationViewController as ProgressViewController
        progressViewController.challenge = challenge
    }
}