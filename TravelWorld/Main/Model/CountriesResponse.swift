//
//  CountriesResponse.swift
//  TravelWorld
//
//  Created by Victor de Paula on 19/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit
import ObjectMapper

class CountriesResponse: NSObject, Mappable {

    var contries: [Country]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        contries <- map["["]
    }
}
