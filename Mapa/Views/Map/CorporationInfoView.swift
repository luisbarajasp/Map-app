//
//  CorporationInfoView.swift
//  Mapa
//
//  Created by Luis Eduardo Barajas Perez on 8/25/19.
//  Copyright © 2019 Luis Barajas. All rights reserved.
//

import UIKit

class CorporationInfoView: UIView {
    
    var controller: MapController?
    
    var corporation: Corporation! {
        didSet {
            nameLabel.text = corporation.name
        }
    }
    
    var distance: String? {
        didSet {
            distanceLabel.text = distance
        }
    }
    
    var eta: String? {
        didSet {
            etaLabel.text = eta
        }
    }
    
    let cornerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.2
        view.layer.masksToBounds = false
        view.clipsToBounds = false
        
        return view
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(self.cancelPressed), for: .touchDown)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 0;
        label.sizeToFit()
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1;
        label.sizeToFit()
        return label
    }()
    
    let etaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1;
        label.sizeToFit()
        return label
    }()
    
    lazy var presentCorporationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mostrar incidentes", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(self.presentCorporationPressed), for: .touchDown)
        button.backgroundColor = UIColor(red: 255, green: 211, blue: 179)
        button.layer.cornerRadius = 12.5
        button.layer.masksToBounds = true
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        
        addSubview(containerView)
        containerView.fillSuperview()
        
        containerView.addSubview(cornerView)
        cornerView.fillSuperview()
        
        cornerView.addSubview(nameLabel)
        nameLabel.anchor(top: cornerView.topAnchor, leading: cornerView.leadingAnchor, bottom: nil, trailing: cornerView.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 30, bottom: 0, right: 30))
        
        cornerView.addSubview(cancelButton)
        cancelButton.anchor(top: cornerView.topAnchor, leading: nil, bottom: nil, trailing: cornerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20), size: CGSize(width: 80, height: 20))
        
        cornerView.addSubview(presentCorporationButton)
        presentCorporationButton.anchor(top: nil, leading: cornerView.leadingAnchor, bottom: cornerView.bottomAnchor, trailing: cornerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20), size: CGSize(width: 0, height: 25))
        
        cornerView.addSubview(distanceLabel)
        distanceLabel.anchor(top: nil, leading: cornerView.leadingAnchor, bottom: presentCorporationButton.topAnchor, trailing: cornerView.centerXAnchor, padding: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 10))
        
        cornerView.addSubview(etaLabel)
        etaLabel.anchor(top: nil, leading: cornerView.centerXAnchor, bottom: presentCorporationButton.topAnchor, trailing: cornerView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 20))
    }
    
    // MARK: - button actions
    @objc
    func cancelPressed() {
        controller?.cancelCorporationPressed()
    }
    
    @objc
    func presentCorporationPressed() {
        controller?.presentCorporationController(corporation: self.corporation)
    }
}
