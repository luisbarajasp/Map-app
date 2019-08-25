//
//  Emergency+CoreDataProperties.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//
//

import Foundation
import CoreData


extension Emergency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Emergency> {
        return NSFetchRequest<Emergency>(entityName: "Emergency")
    }

    @NSManaged public var desc: String?
    @NSManaged public var idCorp: Int32
    @NSManaged public var date: String?
    @NSManaged public var place: String?
    @NSManaged public var corporation: Corporation?

}
