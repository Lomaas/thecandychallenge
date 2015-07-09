import Foundation
import UIKit

class InviteFriendsViewController: UIViewController, UITextFieldDelegate {
    let inviteFriendTableViewCellIdentifier = "InviteFriendTableViewCell"
    typealias Friend = (id: String, name: String, selected: Bool)
    var challenge: Challenge!
    var dataArray = [Friend]()
    var friendsIds = [String]()

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didPressDone(sender: AnyObject) {
        ChallengeService.findAndAddUsersToFriend(friendsIds)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ChallengeService.getMyChallenge { (userChallenge) -> Void in
            self.challenge = userChallenge
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends?fields=name", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                println("Error: \(error)")
            } else {
                println("fetched friends: \(result)")
                
                var friendObjects = result.valueForKey("data") as! [NSDictionary]
                
                for friendObject in friendObjects {
                    self.dataArray.append(Friend(friendObject["id"] as! String, friendObject["name"] as! String, false))
                }
                self.tableView.reloadData()
            }
        })
    }

    private func removeFriend(id: String) {
        for (index, friendId) in enumerate(friendsIds) {
            if friendId == id {
                friendsIds.removeAtIndex(index)
            }
        }
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
        cell.nameLabel.text = dataArray[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if dataArray[indexPath.row].selected {
            removeFriend(dataArray[indexPath.row].id)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
             friendsIds.append(dataArray[indexPath.row].id)
        }
        dataArray[indexPath.row].selected  = !dataArray[indexPath.row].selected
    }
}