//
//  bottomOfCard.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/7/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
class bottomOfCard: UIView {
    
    //MARK:- Elements
    let saveIcon: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "saveIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let moreInfoButton: UIButton = {
        let button = UIButton()
        button.setTitle("\u{2022}\u{2022}\u{2022}", for: .normal)
        button.setTitleColor(wandrBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Book", size: 22)
        return button
    }()
    
    let savesInfo = UIView()
    
    let bottomRowLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let topRowLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 23)
        label.textColor = #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)
        return label
    }()
    
    //MARK:- Setup View
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = cardCornerRadius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        setupBottomOfCard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBottomOfCard() {
        setupMoreInfoButton()
        setupSavesInfo()
        setupBottomBarInfo()
        setupNumberOfSavesCount()
    }

    fileprivate func setupNumberOfSavesCount() {
        savesInfo.addSubview(topRowLabel)
        topRowLabel.anchor(top: savesInfo.topAnchor, bottom: savesInfo.bottomAnchor, leading: savesInfo.leadingAnchor, trailing: nil)
    }
    
    fileprivate func setupMoreInfoButton() {
        addSubview(moreInfoButton)
        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false
        moreInfoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(contentMargin-7)).isActive = true
        moreInfoButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        moreInfoButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        moreInfoButton.widthAnchor.constraint(equalTo: moreInfoButton.heightAnchor).isActive = true
    }
    
    fileprivate func setupSavesInfo() {
        addSubview(savesInfo)
        savesInfo.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: moreInfoButton.leadingAnchor, padding: UIEdgeInsets(top: 2, left: contentMargin, bottom: 0, right: 0))
        savesInfo.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
    }
    
    fileprivate func setupBottomBarInfo() {
        addSubview(bottomRowLabel)
        bottomRowLabel.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: moreInfoButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: contentMargin, bottom: -2, right: 0))
        bottomRowLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
}
