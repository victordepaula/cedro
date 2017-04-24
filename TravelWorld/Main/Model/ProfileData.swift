//
//  ProfileData.swift
//  TravelWorld
//
//  Created by Victor de Paula on 21/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit

class ProfileData: AbstractData {
    
    static let sharedInstance: ProfileData = {
        let instance = ProfileData(entityName: Entidades.profile.rawValue)
        return instance
    }()
    
    init(entityName: String) {
        super.init()
        self.entityName = entityName
    }
    
    func saveProfile(_ data: Profile) -> Any? {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = data.id
        dictionary["name"] = data.name
        dictionary["email"] = data.email
        
        let result = self.save(dictionary)
        return result ?? ""
    }
    
    func getProfile() -> Profile? {
        let profile = Profile()
        let result = get()
        let user = result as! [User]
        
        
        for index in 0..<user.count {
            profile.id = user[index].id
            profile.name = user[index].name
            profile.email = user[index].email
        }
    
        return profile
    }
    
    func getProfiles() -> [Profile?] {
        let profile = Profile()
        var profilesArray = [Profile]()
        let result = get()
        let user = result as! [User]
        
        
        for index in 0..<user.count {
            profile.id = user[index].id
            profile.name = user[index].name
            profile.email = user[index].email
            
            profilesArray.append(profile)
        }
        
        return profilesArray
    }
    
    func getProfileWith(currentUserID: String?) -> Profile? {
        let profile : Profile? = Profile()
        let result = getWithUserId(currentUserID, atributte: .profile)
        let user = result as! [User]
        
        for index in 0..<user.count {
            profile?.id = user[index].id
            profile?.name = user[index].name
            profile?.email = user[index].email
        }
        
        guard let currentProfile = profile else {
            print("Nor Found Profile With CurrentUserID !")
            return Profile()
        }
        
        return currentProfile
    }
    
    func verifyExists(value: String?) -> Bool{
        let profile = getProfiles()
        for index in 0..<profile.count {
            if profile[index]?.id! == value {
                return true
            }
        }
        
        return false
    }
    
    func verifyExistingProfiles() -> Bool{
        let profile = getProfile()
        if profile != nil {
            return true
        }
        
        return false
    }
    
    func removeAllProfiles(){
        removeAll()
    }
    
}
