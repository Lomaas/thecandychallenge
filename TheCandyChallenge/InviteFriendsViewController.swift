import Foundation
import UIKit

class InviteFriendsViewController: UIViewController, UITextFieldDelegate {
    let inviteFriendTableViewCellIdentifier = "InviteFriendTableViewCell"
    var dataArray = []
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends?fields=name", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                println("Error: \(error)")
            } else {
                println("fetched friends: \(result)")

                var friendObjects = result.valueForKey("data") as! [NSDictionary]
                var friendsIds = [String]()
                
                for friendObject in friendObjects {
                    println(friendObject["id"] as! String)
                    friendsIds.append(friendObject["id"] as! String)
                }

                self.findUsers(friendsIds)
            }
        })
    }
    
    @IBAction func nextPressed(sender: AnyObject) {

    }

    @IBAction func didPressDone(sender: AnyObject) {
        // Add friends to challenge
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func findUsers(friendIds: [String]) {
        let friendQuery = PFUser.query()
        friendQuery?.whereKey("fbId", containedIn: friendIds)
        friendQuery?.findObjectsInBackgroundWithBlock({ (result, error) -> Void in
            
        })
    }
}

extension InviteFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(inviteFriendTableViewCellIdentifier, forIndexPath: indexPath) as! InviteFriendTableViewCell
        
        return cell
    }
}