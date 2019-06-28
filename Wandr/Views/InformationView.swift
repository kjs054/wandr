//
//  InformationView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/28/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class InformationView: UIView {
    
    let couchImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "couch"))
        return imageView
    }()
    
    let informationTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NexaBold", size: 20)
        label.textColor = wandrBlue
        label.text = "Lets Make Some Better Plans"
        return label
    }()
    
    let informationSubTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Another night on the couch? \n Send a place to a friend(s) and \n make some plans"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCouchImage()
        setupInformationTitle()
        setupInformationSubTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCouchImage() {
        addSubview(couchImage)
        couchImage.anchor(top: topAnchor, bottom: nil, leading: nil, trailing: nil, padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0))
        couchImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        couchImage.heightAnchor.constraint(equalTo: couchImage.widthAnchor).isActive = true
        couchImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setupInformationTitle() {
        addSubview(informationTitle)
        informationTitle.anchor(top: couchImage.bottomAnchor, bottom: nil, leading: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        informationTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setupInformationSubTitle() {
        addSubview(informationSubTitle)
        informationSubTitle.anchor(top: informationTitle.bottomAnchor, bottom: nil, leading: nil, trailing: nil, padding: UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0))
        informationSubTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
