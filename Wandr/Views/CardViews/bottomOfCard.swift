//
//  bottomOfCard.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/7/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
class bottomOfCard: UIView {
    
    let saveIcon: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "saveIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let moreInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "infoIcon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let savesInfo = UIView()
    
    let friendsWhoSaved = FriendsBubbles()
    let bottomBarInfo: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let numberOfSavesCount: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 23)
        label.text = "0 Likes"
        label.textColor = #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)
        return label
    }()
    
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
    
    fileprivate func setupSaveIcon() {
        savesInfo.addSubview(saveIcon)
        saveIcon.anchor(top: savesInfo.topAnchor, bottom: savesInfo.bottomAnchor, leading: savesInfo.leadingAnchor, trailing: nil)
        saveIcon.widthAnchor.constraint(equalTo: saveIcon.heightAnchor, multiplier: 0.45).isActive = true
    }
    
    fileprivate func setupFriendsWhoSaved() {
        savesInfo.addSubview(friendsWhoSaved)
        friendsWhoSaved.anchor(top: saveIcon.topAnchor, bottom: savesInfo.bottomAnchor, leading: saveIcon.trailingAnchor, trailing: nil)
    }
    
    fileprivate func setupNumberOfSavesCount() {
        savesInfo.addSubview(numberOfSavesCount)
        numberOfSavesCount.anchor(top: savesInfo.topAnchor, bottom: savesInfo.bottomAnchor, leading: friendsWhoSaved.trailingAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width * 0.02, bottom: 0, right: 0))
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
        setupSaveIcon()
        setupFriendsWhoSaved()
    }
    
    fileprivate func setupBottomBarInfo() {
        addSubview(bottomBarInfo)
        bottomBarInfo.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: moreInfoButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: contentMargin, bottom: -2, right: 0))
        bottomBarInfo.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
    
}
