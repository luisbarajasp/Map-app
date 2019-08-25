//
//  File.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//

import UIKit

class MapNavBar: UIView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "Mapa"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        backgroundColor = .white
        addSubview(nameLabel)
        nameLabel.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor)
    }
}
