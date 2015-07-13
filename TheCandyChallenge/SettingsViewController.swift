import Foundation
import UIKit

class SettingsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        let user = UserService.getCurrentUser()!
        let userId = user["fbId"] as! String
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/\(userId)/picture", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                println("Error: \(error.localizedDescription)")
            } else {
//                println("fetched user: \(result)")
            }
        })
    }
}