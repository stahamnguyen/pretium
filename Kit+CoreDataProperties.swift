//
//  Kit+CoreDataProperties.swift
//  Pretium
//
//  Created by Staham Nguyen on 05/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import Foundation
import CoreData


extension Kit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kit> {
        return NSFetchRequest<Kit>(entityName: "Kit")
    }

    @NSManaged public var name: String?
    @NSManaged public var photo: NSObject?
    @NSManaged public var haveGear: NSSet?

}

// MARK: Generated accessors for haveGear
extension Kit {

    @objc(addHaveGearObject:)
    @NSManaged public func addToHaveGear(_ value: Gear)

    @objc(removeHaveGearObject:)
    @NSManaged public func removeFromHaveGear(_ value: Gear)

    @objc(addHaveGear:)
    @NSManaged public func addToHaveGear(_ values: NSSet)

    @objc(removeHaveGear:)
    @NSManaged public func removeFromHaveGear(_ values: NSSet)

}
