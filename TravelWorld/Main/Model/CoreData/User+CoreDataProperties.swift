//
//  User+CoreDataProperties.swift
//  
//
//  Created by Victor de Paula on 21/04/17.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var id: String?

}
