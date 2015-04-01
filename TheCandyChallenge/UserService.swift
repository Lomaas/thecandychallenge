//
//  UserService.swift
//  TheCandyChallenge
//
//  Created by Simen Johannessen on 01/04/15.
//  Copyright (c) 2015 Simen Lomås Johannessen. All rights reserved.
//

import Foundation

struct UserService {
    static func isLoggedIn() -> Bool {
        if ((FBSDKAccessToken.currentAccessToken()) != nil && PFUser.currentUser() != nil) {
            return true;
        }
        
        return false
    }
    
    static func getCurrentUser() -> PFUser! {
        var currentUser = PFUser.currentUser()
        return currentUser
    }
}