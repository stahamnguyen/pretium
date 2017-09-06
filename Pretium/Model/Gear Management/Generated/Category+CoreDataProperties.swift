//
//  Category+CoreDataProperties.swift
//  Pretium
//
//  Created by Staham Nguyen on 21/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var haveGear: NSSet?

}

// MARK: Generated accessors for haveGear
extension Category {

    @objc(addHaveGearObject:)
    @NSManaged public func addToHaveGear(_ value: Gear)

    @objc(removeHaveGearObject:)
    @NSManaged public func removeFromHaveGear(_ value: Gear)

    @objc(addHaveGear:)
    @NSManaged public func addToHaveGear(_ values: NSSet)

    @objc(removeHaveGear:)
    @NSManaged public func removeFromHaveGear(_ values: NSSet)

}
