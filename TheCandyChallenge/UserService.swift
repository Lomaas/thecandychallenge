import Foundation

struct UserService {
    static func hasSignedUp() -> Bool {
        if ((PFUser.currentUser() != nil) && (PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!))) {
            return true
        }
        return false
    }
    
    static func getCurrentUser() -> PFUser! {
        let currentUser = PFUser.currentUser()
        return currentUser
    }
}