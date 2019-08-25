//
//  ViewController.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//

import UIKit

class MapController: UIViewController {
    
    let apiService: APIService = {
        let service = APIService()
        return service
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        fetchCorporations()
    }
    
    func fetchCorporations() {
        apiService.fetchCorporations { (corporations) in
            if corporations != nil {
                print(corporations)
            }
        }
    }


}

