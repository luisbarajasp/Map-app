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
    
    var controller: MapController? {
        didSet {
            corporationInfoView.controller = controller
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    lazy var map: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsScale = true
        map.showsUserLocation = true
        return map
    }()
    
    var isShowingInfo = false
    var corporationTopConstraint: NSLayoutConstraint!
    
    lazy var corporationInfoView: CorporationInfoView = {
        let view = CorporationInfoView()
        view.controller = self.controller
        return view
    }()
    
    var distance: CLLocationDistance? {
        didSet {
            corporationInfoView.distance = Float(self.distance!).stringFromDistance()
        }
    }
    
    var eta: TimeInterval? {
        didSet {
            corporationInfoView.eta = self.eta?.stringFromTimeInterval()
        }
    }
    
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
        
        addSubview(corporationInfoView)
        corporationTopConstraint = corporationInfoView.topAnchor.constraint(equalTo: bottomAnchor)
        corporationTopConstraint.isActive = true
        corporationInfoView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: CGSize(width: 0, height: 200))
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - Map View Delegate Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If it the user locatioin return the default
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }
        
        // Download corporation image from logo url
        if let corpAnnotation = annotation as? Corporation, corpAnnotation.logoURL != nil {
            if let url = URL(string: corpAnnotation.logoURL!) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    //print("RESPONSE FROM API: \(response)")
                    if error != nil {
                        print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                        DispatchQueue.main.async {
                            let pinImage = UIImage(named: "pin")
                            let size = CGSize(width: 50, height: 50)
                            UIGraphicsBeginImageContext(size)
                            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                            
                            annotationView?.image = resizedImage
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data {
                            if let downloadedImage = UIImage(data: data) {
                                imageCache.setObject(downloadedImage, forKey: NSString(string: corpAnnotation.logoURL!))
                                let size = CGSize(width: 50, height: 50)
                                UIGraphicsBeginImageContext(size)
                                downloadedImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                                
                                annotationView?.image = resizedImage
                            }
                        }
                    }
                }).resume()
            }
        }
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.controller?.showSpinner(onView: self)
        if let corp = view.annotation as? Corporation {
            
            if let sourceCoord = controller?.sourceLocation?.coordinate,
                let destCoord = view.annotation?.coordinate {
                
                let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoord))
                let destItem = MKMapItem(placemark: MKPlacemark(coordinate: destCoord))
                
                let directionRequest = MKDirections.Request()
                directionRequest.source = sourceItem
                directionRequest.destination = destItem
                directionRequest.transportType = .automobile
                directionRequest.requestsAlternateRoutes = false
                
                _ = MKDirections(request: directionRequest).calculate { (response, error) in
                    guard let response = response else {
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        return
                    }
                    
                    let route = response.routes[0]
                    self.eta = route.expectedTravelTime
                    self.distance = route.distance
                    self.map.addOverlay(route.polyline, level: .aboveRoads)
                    
                    let rekt = route.polyline.boundingMapRect
                    var coordinateRegion = MKCoordinateRegion(rekt)
                    coordinateRegion.span.latitudeDelta *= 2
                    coordinateRegion.span.longitudeDelta *= 1.3
                    self.map.setRegion(coordinateRegion, animated: true)
                    
                    self.controller?.removeSpinner()
                    
                }
                
                if self.isShowingInfo {
                    self.hideCorporationInfo(corporation: corp)
                }else{
                    self.showCorporationInfo(corporation: corp)
                }
                
            }
            
            
            
        }
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 241, green: 169, blue: 49)
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    // MARK: - Corporation info view methods
    func showCorporationInfo(corporation: Corporation) {
        corporationInfoView.corporation = corporation
        isShowingInfo = true
        corporationTopConstraint.constant = -200
        UIView.animate(withDuration: 0.5, animations: {
            
            self.layoutIfNeeded()
            
        })
    }
    
    func hideCorporationInfo(corporation: Corporation?) {
        corporationTopConstraint.constant = 0
        map.removeOverlays(map.overlays)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        }) { (completed) in
            if completed {
                if self.isShowingInfo && corporation != nil{
                    self.showCorporationInfo(corporation: corporation!)
                }else{
                    if let location = self.controller?.sourceLocation {
                        self.centerMapOnLocation(location: location)
                    }
                }
            }
        }
    }
}
