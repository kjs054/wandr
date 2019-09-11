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
    
    let moreInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "menuDots"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.masksToBounds = false
        return button
    }()

    
    let imageBars: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .clear
        view.spacing = 4
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        let icon = UIImage(named: "saveIcon")?.withRenderingMode(.alwaysTemplate)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(icon, for: .normal)
        button.tintColor = .black
        button.alpha = 0.5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = cardCornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        setupTopOfCard()
    }
    
    fileprivate func setupTopOfCard() {
        setupImage()
        setupImageBars()
        setupSaveButton()
        setupMoreInfoButton()
    }
    
    let topGradient = CAGradientLayer()
    let bottomGradient = CAGradientLayer()
    func setupTopGradintLayer() {
        topGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        topGradient.locations = [0.01,0.45]
        layer.insertSublayer(topGradient, at: 5)
    }
    
    func setupSaveButton() {
        addSubview(saveButton)
        saveButton.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: nil, padding: UIEdgeInsets(top: contentMargin, left: contentMargin, bottom: 0, right: 0))
        saveButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupBottomGradintLayer() {
        bottomGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        bottomGradient.locations = [0.01,0.45]
        bottomGradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        bottomGradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(bottomGradient, at: 6)
    }
    
    override func layoutSubviews() {
        topGradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        bottomGradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    fileprivate func setupMoreInfoButton() {
        addSubview(moreInfoButton)
        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false
        moreInfoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        moreInfoButton.topAnchor.constraint(equalTo: topAnchor, constant: contentMargin).isActive = true
        moreInfoButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        moreInfoButton.widthAnchor.constraint(equalTo: moreInfoButton.heightAnchor).isActive = true
    }

    fileprivate func setupImage() {
        addSubview(imageView)
        imageView.fillSuperView()
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
