//
//  APIService.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class APIService: NSObject {
    lazy var endPoint: String = {
        return "https://api.myjson.com/bins/o0cgl"
    }()
    
    // fetch data
    func fetchData(completion: @escaping ([[NSManagedObject]]?) -> Void) {
        guard let url = URL(string: self.endPoint) else {
            completion(nil)
            return
        }
        
        Alamofire.request(url,
                          method: .get)
        .validate()
        .responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote artists: \(String(describing: response.result.error))")
                completion(nil)
                return
            }
            
            var objects: [[NSManagedObject]] = []
            
            // corporations
            guard let value = response.result.value as? [String: AnyObject],
                let corpResults = value["corporations"] as? [[String: AnyObject]] else {
                    print("Malformed data received from fetchArtists service")
                    completion(nil)
                    return
            }
            
            var corporations: [Corporation] = []
            
            for corpJSON in corpResults {
                if let corp = self.jsonToCorp(jsonData: corpJSON) as? Corporation {
                    corporations.append(corp)
                }
            }
            
            objects.append(corporations)
            
            // emergencies
            guard let emerResults = value["emergencies"] as? [[String: AnyObject]] else {
                    print("Malformed data received from fetchArtists service")
                    completion(nil)
                    return
            }
            
            var emergencies: [Emergency] = []
            
            for emerJSON in emerResults {
                if let emergency = self.jsonToEmergency(jsonData: emerJSON) as? Emergency {
                    emergencies.append(emergency)
                }
            }
            
            objects.append(emergencies)
            
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
            } catch let error {
                print(error)
            }
            
            completion(objects)
        }
    }
    
    // Create the corporation entity from json
    private func jsonToCorp(jsonData: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let id = jsonData["idCorp"] as! Int
        
        // Check if corporation already exists
        if let corp = corporationExists(context: context, id: id) {
            return corp
        }else{
            // it doesn't exist, save it to CoreData
            if let corpEntity = NSEntityDescription.insertNewObject(forEntityName: "Corporation", into: context) as? Corporation {
                corpEntity.id = Int32(id)
                corpEntity.name = jsonData["name"] as? String
                corpEntity.desc = jsonData["description"] as? String
                corpEntity.logoURL = jsonData["logo"] as? String
                corpEntity.coord = jsonData["coordinates"] as? String
                
                return corpEntity
            }
        }
        
        return nil
        
    }
    
    // Create the emergency entity from json
    private func jsonToEmergency(jsonData: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let idCorp = jsonData["idCopor"] as! Int
        let desc = jsonData["descripción"] as! String
        
        // Check if corporation already exists
        if let emergency = emergencyExists(context: context, desc: desc) {
            return emergency
        }else{
            // it doesn't exist, save it to CoreData
            if let emergencyEntity = NSEntityDescription.insertNewObject(forEntityName: "Emergency", into: context) as? Emergency {
                emergencyEntity.idCorp = Int32(idCorp)
                emergencyEntity.desc = desc
                emergencyEntity.date = jsonData["date"] as? String
                emergencyEntity.place = jsonData["place"] as? String
                
                return emergencyEntity
            }
        }
        
        return nil
        
    }
    
    // Check if corporation already exists
    private func corporationExists(context: NSManagedObjectContext, id: Int) -> Corporation? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Corporation")
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        request.fetchLimit = 1
        
        do{
            if let corp = try context.fetch(request).first as? Corporation {
                return corp
            }else{
                return nil
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
    
    // Check if emergency already exists
    private func emergencyExists(context: NSManagedObjectContext, desc: String) -> Emergency? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Emergency")
        let predicate = NSPredicate(format: "desc == %@", desc)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do{
            if let emer = try context.fetch(request).first as? Emergency {
                return emer
            }else{
                return nil
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return nil
    }
}
