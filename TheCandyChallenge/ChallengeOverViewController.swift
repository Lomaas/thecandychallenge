//
//  ChallengeOverViewController.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 07/08/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import UIKit

class ChallengeOverViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = UserService.getCurrentUser()!
        nameLabel.text = user["name"] as? String
    }

    @IBAction func didPressStartNewChallenge(sender: AnyObject) {
        
    }
}
