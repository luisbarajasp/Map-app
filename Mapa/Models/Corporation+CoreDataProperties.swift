//
//  Corporation+CoreDataProperties.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//
//

import Foundation
import CoreData


extension Corporation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Corporation> {
        return NSFetchRequest<Corporation>(entityName: "Corporation")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var logoURL: String?
    @NSManaged public var coord: String?
    @NSManaged public var emergencies: NSSet?

}

// MARK: Generated accessors for emergencies
extension Corporation {

    @objc(addEmergenciesObject:)
    @NSManaged public func addToEmergencies(_ value: Emergency)

    @objc(removeEmergenciesObject:)
    @NSManaged public func removeFromEmergencies(_ value: Emergency)

    @objc(addEmergencies:)
    @NSManaged public func addToEmergencies(_ values: NSSet)

    @objc(removeEmergencies:)
    @NSManaged public func removeFromEmergencies(_ values: NSSet)

}
