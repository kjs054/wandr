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
    
    let categoryBubble: infoBubble = {
        let bubble = infoBubble()
        bubble.titleLabel!.adjustsFontSizeToFitWidth = true
        bubble.titleLabel!.font = UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 24)
        bubble.setTitleColor(#colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1), for: .normal)
        return bubble
    }()
    
    let pricingBubble: infoBubble = {
        let bubble = infoBubble()
        bubble.titleLabel!.adjustsFontSizeToFitWidth = true
        bubble.titleLabel!.font = UIFont(name: "Avenir-Black", size: UIScreen.main.bounds.width / 22)
        bubble.setTitleColor(#colorLiteral(red: 0.07058823529, green: 0.8549019608, blue: 0.462745098, alpha: 1), for: .normal)
        return bubble
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
        setupCategoryBubble()
        setupPricingBubble()
        setupImageBars()
    }
    
    let gradient = CAGradientLayer()
    func setupGradientLayer() {
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0,0.35]
        layer.addSublayer(gradient)
    }
    
    override func layoutSubviews() {
        gradient.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    fileprivate func setupCategoryBubble() {
        addSubview(categoryBubble)
        categoryBubble.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: contentMargin, bottom: -contentMargin, right: 0))
        categoryBubble.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.48).isActive = true
        categoryBubble.heightAnchor.constraint(equalTo: categoryBubble.widthAnchor, multiplier: 0.23).isActive = true
    }
    
    fileprivate func setupImage() {
        addSubview(imageView)
        imageView.fillSuperView()
    }
    
    fileprivate func setupHeader() {
        addSubview(headerInfo)
        headerInfo.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: contentMargin, left: contentMargin, bottom: 0, right: 0))
    }
    
    fileprivate func setupPricingBubble() {
        addSubview(pricingBubble)
        pricingBubble.anchor(top: nil, bottom: bottomAnchor, leading: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: -contentMargin, right: -contentMargin))
        pricingBubble.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.37).isActive = true
        pricingBubble.heightAnchor.constraint(equalTo: pricingBubble.widthAnchor, multiplier: 0.30).isActive = true
    }
    
    fileprivate func setupImageBars() {
        addSubview(imageBars)
        imageBars.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 5, bottom: -5, right: -5))
        imageBars.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
