//
//  MapView.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapView: UIView, MKMapViewDelegate {
    
    var controller: MapController!
    
    let regionRadius: CLLocationDistance = 1000
    
    lazy var map: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsScale = true
//        map.showsPointsOfInterest = true
        map.showsUserLocation = true
        return map
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        addSubview(map)
        map.fillSuperview()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
}
