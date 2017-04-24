//
//  CountryData.swift
//  TravelWorld
//
//  Created by Victor de Paula on 22/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit

class CountryData: AbstractData {
    
    static let sharedInstance: CountryData = {
        let instance = CountryData(entityName: Entidades.paises.rawValue)
        return instance
    }()
    
    init(entityName: String) {
        super.init()
        self.entityName = entityName
    }
    
    func saveCountry(_ data: Country, userID: String) -> Any? {
        var dictionary: [String: Any] = [:]
        dictionary["user_id"] = userID
        dictionary["id"] = data.id
        dictionary["shortname"] = data.shortname
        dictionary["longname"] = data.longname
        dictionary["iso"] = data.iso
        dictionary["callingcode"] = data.callingCode
        dictionary["culture"] = data.culture
        dictionary["status"] = data.status
        dictionary["isvisited"] = data.isvisited
        dictionary["checkin"] = data.checkin
        
        let result = self.save(dictionary)
        return result ?? ""
    }
    
    func getCountriesWith(userId: String) -> [Country]? {
        var countriesArray = [Country]()
        let result = getWithUserId(userId, atributte: .country)
        let fetchCountry = result as! [Countries]
        
        
        for index in 0..<fetchCountry.count {
            let country = Country()
            country.id = fetchCountry[index].id
            country.shortname = fetchCountry[index].shortname
            country.longname = fetchCountry[index].longname
            country.iso = fetchCountry[index].iso
            country.callingCode = fetchCountry[index].callingcode
            country.culture = fetchCountry[index].culture
            country.isvisited = fetchCountry[index].isvisited
            country.checkin = fetchCountry[index].checkin
            countriesArray.append(country)
        }
        
        return countriesArray
    }
    
    func verifyCountryExistWith(userID: String, countryID: Int32) -> Country? {
        let result = getWithUserIdAndCountryId(value: userID, countryID: countryID, attribute: .country)
        let fetchCountry = result as? [Countries]
        
        if fetchCountry?.count != 0 {
            if let CountryResult = fetchCountry?[0] {
                print("\(CountryResult.shortname!) is Encountered in Database !")
                let country = Country()
                country.id = CountryResult.id
                country.shortname = CountryResult.shortname
                country.longname = CountryResult.longname
                country.iso = CountryResult.iso
                country.callingCode = CountryResult.callingcode
                country.culture = CountryResult.culture
                country.isvisited = CountryResult.isvisited
                country.checkin = CountryResult.checkin
                return country
            }
        }
        
        return nil
    }
    
    func updateCountryWith(currentUserUD: String?, country: Country){
        let isUpdated = updateCountryWithUserID(value: currentUserUD, country: country, attribute: .country)
        if isUpdated {
            print("Country \(country.shortname) is Updated Successfully !")
        }
    }
    
    func removeCountryWith(currentUserID: String?) -> Bool? {
        let isSuccess = removeWithUserId(value: currentUserID, attribute: .country)
        return isSuccess
    }

    
}
