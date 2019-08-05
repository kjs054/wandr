//
//  topOfCard.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/8/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class topOfCard: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let headerInfo: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.text = "Error Could Not Get Data"
        label.layer.masksToBounds = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let imageBars: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.spacing = 4
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        clipsToBounds = true
        layer.cornerRadius = cardCornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupTopOfCard()
    }
    
    fileprivate func setupTopOfCard() {
        setupImage()
        setupGradientLayer()
        setupHeader()
        setupImageBars()
    }
    
    let gradient = CAGradientLayer()
    func setupGradientLayer() {
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.01,0.45]
        layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        gradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    fileprivate func setupImage() {
        addSubview(imageView)
        imageView.fillSuperView()
    }
    
    fileprivate func setupHeader() {
        addSubview(headerInfo)
        headerInfo.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: contentMargin, left: contentMargin, bottom: 0, right: contentMargin))
    }
    
    fileprivate func setupImageBars() {
        addSubview(imageBars)
        imageBars.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5))
        imageBars.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
