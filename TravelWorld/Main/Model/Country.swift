//
//  Country.swift
//  TravelWorld
//
//  Created by Victor de Paula on 19/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit
import ObjectMapper

class Country: NSObject, Mappable {

    var id: Int32?
    var iso: String?
    var shortname: String?
    var longname: String?
    var callingCode: String?
    var status: String? = "1"
    var culture: String?
    var isvisited: Bool?
    var checkin: String?
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        iso <- map["iso"]
        shortname <- map["shortname"]
        longname <- map["longname"]
        callingCode <- map["callingCode"]
        culture <- map["culture"]
    }
}
