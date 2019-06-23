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
    let profileImages: circularButton = {
        let view = circularButton()
        view.backgroundColor = wandrBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Heavy", size: 19)
        label.textColor = wandrBlue
        label.text = "Title"
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Medium", size: 16)
        label.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        label.text = "Sub Title"
        return label
    }()
    
    let radioButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "checked"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = wandrBlue.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 15
        return button
    }()
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 16)
        label.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        label.text = "2h"
        return label
    }()
    
    //MARK:- View Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileImages()
        addSubview(title)
        title.leftAnchor.constraint(equalTo: profileImages.rightAnchor, constant: 15).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        addSubview(subTitle)
        subTitle.anchor(top: title.bottomAnchor, bottom: nil, leading: profileImages.trailingAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 15, bottom: -25, right: 0))
    }
    
    func setupProfileImages() {
        addSubview(profileImages)
        profileImages.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8).isActive = true
        profileImages.widthAnchor.constraint(equalTo: profileImages.heightAnchor).isActive = true
        profileImages.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setupRadioButton() {
        addSubview(radioButton)
        radioButton.addTarget(self, action: #selector(radioButtonClicked), for: .touchUpInside)
        radioButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        radioButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        radioButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        radioButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupTimeStamp() {
        addSubview(timeStamp)
        timeStamp.anchor(top: nil, bottom: nil, leading: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -15))
        timeStamp.centerYAnchor.constraint(equalTo: subTitle.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Logic
    @objc func radioButtonClicked(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
}
