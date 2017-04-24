//
//  Profile.swift
//  TravelWorld
//
//  Created by Victor de Paula on 21/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit
import ObjectMapper

class Profile: NSObject, Mappable {
    var id: String?
    var name: String?
    var email: String?
    var profile_image: String?
    
    override init(){}
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        email <- map["email"]
    }
}
