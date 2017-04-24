//
//  Countries+CoreDataProperties.swift
//  
//
//  Created by Victor de Paula on 21/04/17.
//
//

import Foundation
import CoreData


extension Countries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Countries> {
        return NSFetchRequest<Countries>(entityName: "Countries");
    }

    @NSManaged public var id: Int32
    @NSManaged public var user_id: String?
    @NSManaged public var iso: String?
    @NSManaged public var shortname: String?
    @NSManaged public var longname: String?
    @NSManaged public var callingcode: String?
    @NSManaged public var status: String?
    @NSManaged public var culture: String?
    @NSManaged public var isvisited: Bool
    @NSManaged public var checkin: String?

}
