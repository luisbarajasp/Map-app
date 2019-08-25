//
//  ViewController.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//

import UIKit
import CoreData

class MapController: UIViewController {
    
    let apiService: APIService = {
        let service = APIService()
        return service
    }()
    
    var corporations: [Corporation] = []
    var emergencies: [Emergency] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
//        clearEmergencies()
//        clearCorporations()
        
        fetchCorporations()
    }
    
    func fetchCorporations() {
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

}

