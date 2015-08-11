//
//  ChallengeOverViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 07/08/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import UIKit

class ChallengeOverViewController: UIViewController {

    var challenge: Challenge!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func didPressStartNewChallenge(sender: AnyObject) {
        challenge.restartChallenge()
        ChallengeService.sharedInstance.updateChallenge(challenge)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserService.getCurrentUser()!
        nameLabel.text = user["name"] as? String
    }
}
