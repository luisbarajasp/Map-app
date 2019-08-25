//
//  Corporation+CoreDataClass.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit


public class Corporation: NSManagedObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        let fullNameArr = coord!.components(separatedBy: ",")
        
        let lat = (fullNameArr[0] as NSString).doubleValue
        let long = (fullNameArr[1] as NSString).doubleValue
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    public var title: String? {
        return self.name ?? ""
    }
}
