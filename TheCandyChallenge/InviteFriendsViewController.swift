import Foundation
import UIKit

class InviteFriendsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func nextPressed(sender: AnyObject) {

    }

    @IBAction func didPressDone(sender: AnyObject) {
        // Add friends to challenge
        dismissViewControllerAnimated(true, completion: nil)
    }
}