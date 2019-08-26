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
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0;
        label.sizeToFit()
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
        
        addSubview(containerView)
        containerView.fillSuperview()
        
        containerView.addSubview(cornerView)
        cornerView.fillSuperview()
        
        cornerView.addSubview(nameLabel)
        nameLabel.anchor(top: cornerView.topAnchor, leading: cornerView.leadingAnchor, bottom: nil, trailing: cornerView.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 30, bottom: 0, right: 30))
        
        cornerView.addSubview(cancelButton)
        cancelButton.anchor(top: cornerView.topAnchor, leading: nil, bottom: nil, trailing: cornerView.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20), size: CGSize(width: 80, height: 20))
    }
    
    // MARK: - button actions
    @objc
    func cancelPressed() {
        controller?.cancelCorporationPressed()
    }
}
