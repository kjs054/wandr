//
//  SendPlanTitleBarView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/24/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class PlanChatTitleBar: UIView {
    
    let navigationTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Chat"
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.textColor = wandrBlue
        return label
    }()
    
    fileprivate lazy var membersColleciton: membersBubblesCollection = {
        let mbc = membersBubblesCollection(chatMembers: members)
        mbc.translatesAutoresizingMaskIntoConstraints = false
        return mbc
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -5).isActive = true
    }
    
    fileprivate func setupMembersCollection() {
        addSubview(membersColleciton)
        if (UIApplication.shared.delegate?.window??.safeAreaInsets.top) != nil {
            navigationTitle.topAnchor.constraint(equalTo: topAnchor).isActive = true
            membersColleciton.topAnchor.constraint(equalTo: navigationTitle.bottomAnchor, constant: 8).isActive = true
        }
        membersColleciton.leftAnchor.constraint(equalTo: leftAnchor, constant: contentMargin).isActive = true
        membersColleciton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        membersColleciton.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -contentMargin).isActive = true
    }
    
    fileprivate func setupNavigationTitle() {
        addSubview(navigationTitle)
        navigationTitle.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -11).isActive = true
        navigationTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: contentMargin).isActive = true
        addSubview(navigationSubtitle)
        navigationSubtitle.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 11).isActive = true
        navigationSubtitle.leftAnchor.constraint(equalTo: leftAnchor, constant: contentMargin).isActive = true
        navigationSubtitle.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -contentMargin).isActive = true
        navigationSubtitle.text = "Members"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
