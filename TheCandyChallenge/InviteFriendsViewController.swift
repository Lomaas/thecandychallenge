import Foundation
import UIKit

class InviteFriendsViewController: UIViewController, UITextFieldDelegate {
    var challenge: PFObject?
    
    @IBOutlet weak var searchField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        ChallengeService.createChallenge()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let progressViewController = segue.destinationViewController as! ProgressViewController
        progressViewController.challenge = challenge
    }
}