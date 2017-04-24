//
//  CountriesApplication.swift
//  TravelWorld
//
//  Created by Victor de Paula on 19/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit
import ObjectMapper

class CountriesApplication: NSObject {
    
    var CountriesProxyUser: CountriesProxy = CountriesProxy()
    let BASE_URL = (UIApplication.shared.delegate as! AppDelegate).BASE_URL
    
    func countries(onSuccess: @escaping (_ result: [Country]) -> Void, onFailureMessage: @escaping (_ failureMessage: String)-> Void, onFailure: @escaping (_ failure:String)-> Void){
        
        CountriesProxyUser.getContries(url: URL(string:"\(BASE_URL)world/countries/active")!, onCompletion: {(response: String) -> Void in
            
            let mapper = Mapper<Country>()
            let countries = mapper.mapArray(JSONString: response)
            if let countries = countries{
                onSuccess(countries)
            }
            
        }, onFailure: {(error:Error) -> Void in
            onFailure(error.localizedDescription)
            
        })
        
    }
}
