import Foundation
import UIKit

class InviteFriendsViewController: UIViewController, UITextFieldDelegate {
    let inviteFriendTableViewCellIdentifier = "InviteFriendTableViewCell"
    typealias Friend = (id: String, name: String, selected: Bool)
    var challenge: Challenge!
    var dataArray = [Friend]()
    var friendsIds = [String]()
    var isChanged = false

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didPressDone(sender: AnyObject) {
        if isChanged {
            ChallengeService.sharedInstance.findAndAddUsersToFriend(friendsIds)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
                
                for friendObject in friendObjects {
                    var id =  friendObject["id"] as! String
                    var selected = self.isFriend(id)

                    if selected {
                        self.friendsIds.append(id)
                    }
                    
                    self.dataArray.append(Friend(id, friendObject["name"] as! String, selected))
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
    
    private func isFriend(id: String) -> Bool {
        for (index, friend) in enumerate(challenge.friends) {
            if friend.id == id {
                return true
            }
        }
        return false
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
        println("checked. \(dataArray[indexPath.row].selected)")
        cell.checkmarkImageView.image = dataArray[indexPath.row].selected ? UIImage(named: "checked") : nil
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        isChanged = true
        
        if dataArray[indexPath.row].selected {
            removeFriend(dataArray[indexPath.row].id)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
             friendsIds.append(dataArray[indexPath.row].id)
        }
        
        dataArray[indexPath.row].selected  = !dataArray[indexPath.row].selected
        tableView.reloadData()
    }
}