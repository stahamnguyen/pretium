//
//  Gear+CoreDataProperties.swift
//  Pretium
//
//  Created by Staham Nguyen on 05/08/2017.
//  Copyright © 2017 Staham Nguyen. All rights reserved.
//

import Foundation
import CoreData


extension Gear {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gear> {
        return NSFetchRequest<Gear>(entityName: "Gear")
    }

    @NSManaged public var photo: NSObject?
    @NSManaged public var manufacturer: String?
    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var serialNumber: Int32
    @NSManaged public var receipt: NSObject?
    @NSManaged public var price: Double
    @NSManaged public var used: Bool
    @NSManaged public var dateOfPurchase: NSDate?
    @NSManaged public var note: String?
    @NSManaged public var belongToKit: NSSet?

}

// MARK: Generated accessors for belongToKit
extension Gear {

    @objc(addBelongToKitObject:)
    @NSManaged public func addToBelongToKit(_ value: Kit)

    @objc(removeBelongToKitObject:)
    @NSManaged public func removeFromBelongToKit(_ value: Kit)

    @objc(addBelongToKit:)
    @NSManaged public func addToBelongToKit(_ values: NSSet)

    @objc(removeBelongToKit:)
    @NSManaged public func removeFromBelongToKit(_ values: NSSet)

}
