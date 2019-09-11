//
//  ContactView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/12/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class ChatUserView: UIView {
    
    //MARK:- Elements
    let profileImage: circularImageView = {
        let imageView = circularImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let leftColorIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Heavy", size: 19)
        label.textColor = UIColor.mainBlue
        return label
    }()
    
    let joinedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Medium", size: 16)
        label.textColor = UIColor.customGrey
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let actionButton: UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "menuDots"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK:- View Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        setupProfileImage()
        setupColorIndicatorView()
        setupNameLabel()
        setupActionButton()
        setupJoinedLabel()
    }
    
    //Static Element Functions
    func setupProfileImage() {
        addSubview(profileImage)
        profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: contentMargin).isActive = true
        profileImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
        profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setupColorIndicatorView() {
        addSubview(leftColorIndicator)
        leftColorIndicator.anchor(top: topAnchor, bottom: bottomAnchor, leading: profileImage.trailingAnchor, trailing: nil, padding: UIEdgeInsets(top: 5, left: contentMargin, bottom: 5, right: 0))
        leftColorIndicator.widthAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: leftColorIndicator.rightAnchor, constant: 15).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
    }
    
    func setupJoinedLabel() {
        addSubview(joinedLabel)
        joinedLabel.anchor(top: nameLabel.bottomAnchor, bottom: nil, leading: leftColorIndicator.trailingAnchor, trailing: actionButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: contentMargin, bottom: 25, right: contentMargin))
    }
    
    func setupActionButton() {
        addSubview(actionButton)
        actionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentMargin).isActive = true
        actionButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: actionButton.leftAnchor).isActive = true
    }
    
    //MARK:- Logic
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func radioButtonClicked(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
}
