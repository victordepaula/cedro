//
//  AbstractData.swift
//  TravelWorld
//
//  Created by Victor de Paula  on 21/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit
import CoreData

class AbstractData: NSObject {
    
    enum Entidades: String {
        case profile = "User"
        case paises = "Countries"
    }
    
    enum Attributtes : String {
        case profile = "id"
        case country = "user_id"
    }
    
    var entityName: String!
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func save(_ data: [String: Any]) -> Any? {
        
        let managedContext = getContext()
        let entity = NSEntityDescription.entity(forEntityName: entityName , in: managedContext)!
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        for key in data.keys {
            let value = data[key]
            object.setValue(value, forKey: key)
        }
        
        do {
            try managedContext.save()
            return object
            
        } catch let error as NSError {
            return error
            
        }
    }
    
    func get() -> Any {
        
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let response = try managedContext.fetch(fetchRequest)
            return response
            
        } catch let error as NSError {
            return error
            
        }
    }
    
    func getWithUserId(_ value: String?, atributte: Attributtes?) -> Any {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(atributte!.rawValue) == \(value!)")
        
        do {
            let response = try managedContext.fetch(fetchRequest)
            return response
            
        } catch let error as NSError {
            return error
            
        }
    }
    
    func getWithUserIdAndCountryId(value: String?, countryID: Int32?, attribute: Attributtes?) -> Any {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(attribute!.rawValue) == \(value!) AND id == \(countryID!)")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        
        } catch let error as NSError {
            print("Fetch for userID in \(entityName) error : \(error) \(error.userInfo)")
            return error
        }
        
    }
    
    func updateCountryWithUserID(value: String?, country: Country, attribute: Attributtes?) -> Bool{
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(attribute!.rawValue) == \(value!) AND id == \(country.id!)")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let countryResult = results[0] as! Countries
            countryResult.checkin = country.checkin!
            countryResult.id =  country.id!
            countryResult.shortname =  country.shortname
            countryResult.longname = country.longname
            countryResult.iso = country.iso
            countryResult.callingcode = country.callingCode
            countryResult.culture = country.culture
            countryResult.isvisited = country.isvisited!
            
            try managedContext.save()
            return true
            
        } catch let error as NSError {
            print("Fetch for userID in \(entityName) error : \(error) \(error.userInfo)")
            return false
        }

    }
    
    func removeWithUserId(value: String?, attribute: Attributtes?) -> Bool {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(attribute!.rawValue) == \(value!)")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject 
                managedContext.delete(managedObjectData)
                print("Detele data for userID in \(entityName) Successfully")
                return true
            }
        } catch let error as NSError {
            print("Detele data for userID in \(entityName) error : \(error) \(error.userInfo)")
            
        }
            return false
    }
    
    func removeWithUserIdAndCountryId(value: String?, countryID: Int32, attribute: Attributtes?) -> Bool {
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "\(attribute!.rawValue) == \(value!) AND id == \(countryID)")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject
                managedContext.delete(managedObjectData)
                print("Detele data for userID in \(entityName) Successfully")
                return true
            }
        } catch let error as NSError {
            print("Detele data for userID in \(entityName) error : \(error) \(error.userInfo)")
            
        }
        return false
    }
    
    func removeAll(){
        
        let managedContext = getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results {
                let managedObjectData:NSManagedObject = managedObject 
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entityName) error : \(error) \(error.userInfo)")

        }
    }
    
    
}
