//
//  CreateMessageView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/17/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class CreateMessageView: UIView {
    
    let messageField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.layer.cornerRadius = 5
        field.placeholder = "Type A Message..."
        field.font = UIFont(name: "Avenir-Medium", size: 18)
        field.returnKeyType = .send
        return field
    }()
    
    let placeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "maps-and-flags").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupShadow()
        setupMessageField()
        setupPlaceButton()
    }
    
    fileprivate func setupShadow() {
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
    }
    
    fileprivate func setupMessageField() {
        addSubview(messageField)
        messageField.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        messageField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
    }
    
    fileprivate func setupPlaceButton() {
        addSubview(placeButton)
        placeButton.anchor(top: topAnchor, bottom: bottomAnchor, leading: messageField.trailingAnchor, trailing: trailingAnchor)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
