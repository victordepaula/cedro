//
//  RestAPI.swift
//  TravelWorld
//
//  Created by Victor de Paula on 18/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit
import Alamofire

public class RestAPI {

    public func restApiPost(url: URL, params: [String: Any], onCompletion: @escaping (_ response: String) -> Void,
                            onFailure: @escaping (_ error: Error) -> Void){
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { response in
            
            switch response.result{
                
            case .success:
                onCompletion(response.result.value!)
                
            case .failure:
                onFailure(response.result.error!)
                
            }
        }
    }
    
    public func restApiGet(url: URL, onCompletion: @escaping (_ response: String) -> Void,
                           onFailure: @escaping (_ error: Error) -> Void){
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default).responseString { response in
            
            switch response.result{
                
            case .success:
                onCompletion(response.result.value!)
                
            case .failure:
                onFailure(response.result.error!)
                
            }
        }
    }

}
