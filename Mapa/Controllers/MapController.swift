//
//  ViewController.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class MapController: UIViewController, CLLocationManagerDelegate {
    
    let apiService: APIService = {
        let service = APIService()
        return service
    }()
    
    var corporations: [Corporation] = [] {
        didSet {
            mapView.map.addAnnotations(corporations)
        }
    }
    var emergencies: [Emergency] = []
    
    lazy var mapView: MapView = {
        let mapView = MapView()
        mapView.controller = self
        return mapView
    }()
    
    var locationManager: CLLocationManager!
    var sourceLocation: CLLocation? {
        didSet{
            
            if let location = sourceLocation {
                mapView.centerMapOnLocation(location: location)
            }
        }
    }
    var destinationCoordinates: CLLocationCoordinate2D?
    
    let backgroundStatuBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let mapNavBar = MapNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        clearEmergencies()
//        clearCorporations()
        
        fetchData()
        setUplocationManager()
        setUpViews()
    }
    
    func fetchData() {
        apiService.fetchData { (objects) in
            if objects != nil && objects!.count > 1 {
                if let corporations = objects![0] as? [Corporation] {
                    self.corporations = corporations
                }
                if let emergencies = objects![0] as? [Emergency] {
                    self.emergencies = emergencies
                }
            }
        }
    }
    
    func setUplocationManager() {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
    }
    
    func setUpViews() {
        view.addSubview(mapView)
        mapView.fillSuperview()
        
        view.addSubview(backgroundStatuBarView)
        backgroundStatuBarView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
        view.addSubview(mapNavBar)
        mapNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 60))
    }
    
    // MARK: - clearData from CoreData for debugging
    private func clearCorporations() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Corporation")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    private func clearEmergencies() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emergency")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    // MARK: - Callbacks
    func cancelCorporationPressed() {
        mapView.isShowingInfo = false
        mapView.hideCorporationInfo(corporation: nil)
    }
    
    // MARK: - LocationManager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        sourceLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            locationManager.stopUpdatingLocation()
        @unknown default:
            break;
        }
    }

}

