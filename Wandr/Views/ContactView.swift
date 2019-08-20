//
//  ContactView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/12/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class ContactView: UIView {
    
    //MARK:- Elements    
    let profileImageView: circularView = {
        let piv = circularView()
        piv.translatesAutoresizingMaskIntoConstraints = false
        return piv
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let initialsLabel: UILabel = { //Used for non-registered users
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 28)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Heavy", size: 19)
        label.textColor = UIColor.mainBlue
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Medium", size: 16)
        label.textColor = UIColor.customGrey
        return label
    }()
    
    let inviteButton: UIButton = {
        var button = UIButton()
        button.setTitle("Invite", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.layer.borderWidth = 3.0
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.backgroundColor = .white
        button.layer.cornerRadius = 14
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 15)
        return button
    }()
    
    let radioButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "checked"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 15
        return button
    }()
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 16)
        label.textColor = UIColor.customGrey
        label.text = "2h"
        return label
    }()
    
    //MARK:- View Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        setupProfileImageView()
        setupTitle()
        setupSubTitle()
    }
    
    //Static Element Functions
    func setupProfileImageView() {
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: contentMargin).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setupTitle() {
        addSubview(title)
        title.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
    }
    
    func setupSubTitle() {
        addSubview(subTitle)
        subTitle.anchor(top: title.bottomAnchor, bottom: nil, leading: profileImageView.trailingAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 15, bottom: 25, right: 0))
    }
    
    //Dynamic Element Functions
    func setupInitialsLabel() {
        profileImageView.addSubview(initialsLabel)
        initialsLabel.widthAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        initialsLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    }
    
    func setupProfileImage() {
        profileImageView.addSubview(profileImage)
        profileImage.widthAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
    }
    
    func setupRadioButton() {
        addSubview(radioButton)
        radioButton.addTarget(self, action: #selector(radioButtonClicked), for: .touchUpInside)
        radioButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentMargin).isActive = true
        radioButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        radioButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        radioButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        title.rightAnchor.constraint(equalTo: radioButton.leftAnchor).isActive = true
    }
    
    func setupInviteButton() {
        addSubview(inviteButton)
        inviteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentMargin).isActive = true
        inviteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inviteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        inviteButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        title.rightAnchor.constraint(equalTo: inviteButton.leftAnchor).isActive = true
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
