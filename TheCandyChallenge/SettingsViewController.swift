import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
        let user = UserService.getCurrentUser()!
        nameLabel.text = user["name"] as? String
        let userId = user["fbId"] as! String
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/\(userId)/picture?redirect=false&type=large&width=640&height=640", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                println("Error: \(error.localizedDescription)")
            } else {
                println("fetched user: \(result)")
                var response = result.valueForKey("data") as! NSDictionary

                if let url = response["url"] as? String {
                    self.fetchAndSetProfileImage(url)
                }
            }
        })
    }
    
    private func fetchAndSetProfileImage(url: String) {
        let data = NSData(contentsOfURL: NSURL(string: url)!)!
        profileImageView.image = UIImage(data: data)
    }
}