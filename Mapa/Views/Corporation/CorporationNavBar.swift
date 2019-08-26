//
//  CorporationNavBar.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//

import UIKit

class CorporationNavBar: UIView {
    
    var controller: CorporationController? 
    
    lazy var backButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(self.backButtonPressed), for: .touchDown)
        b.setImage(UIImage(named: "back"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        backgroundColor = .white
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0), size: CGSize(width: 30, height: 0))
    }
    
    @objc
    func backButtonPressed() {
        controller?.navigationBackPressed()
    }
}
