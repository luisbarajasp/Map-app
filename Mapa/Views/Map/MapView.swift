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
        
//        annotationView?.canShowCallout = true
//        annotationView?.calloutOffset = CGPoint(x: -8, y: 0)
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}
