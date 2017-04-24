//
//  UserManager.swift
//  TravelWorld
//
//  Created by Victor de Paula on 22/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    
    //MARK: Singleton
    
    static let sharedInstance : UserManager = {
        let instance = UserManager()
        return instance
    }()
    
    //MARK: Enums
    
    enum CacheUtil : String {
        case LoggedKey = "isLgd_Key"
        case UserIDKey = "UsrID_Key"
    }
    
    //MARK: Constants
    
    let Cache = UserDefaults.standard
    
    
    //MARK: Methods
    
    func userIsLogged(value: Bool){
        Cache.set(value, forKey: CacheUtil.LoggedKey.rawValue)
    }
    
    func saveCurrentUserID(value: String?) {
        Cache.set(value, forKey: CacheUtil.UserIDKey.rawValue)
    }
    
    func getCurrentUserID() -> String? {
        let userID = Cache.object(forKey: CacheUtil.UserIDKey.rawValue) as? String
        return userID
    }
    
    func currentUserIsLogged() -> Bool? {
        if let isLogged = Cache.object(forKey: CacheUtil.LoggedKey.rawValue) as? Bool {
            return isLogged
        }
        return false
    }
}
