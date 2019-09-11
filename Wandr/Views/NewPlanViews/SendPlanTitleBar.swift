//
//  SendPlanTitleBarView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/24/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class SendPlanTitleBar: UIView {
    
    let navigationTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Send A Plan"
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.textColor = UIColor.mainBlue
        return label
    }()
    
    let navigationSubtitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.textColor = UIColor.customGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate func setupCloseButton() {
        addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 0)
    }
    
    fileprivate func setupNavigationTitle() {
        addSubview(navigationTitle)
        navigationTitle.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -11).isActive = true
        navigationTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: contentMargin).isActive = true
    }
    
    fileprivate func setupNavigationSubtitle(_ planTitle: String) {
        addSubview(navigationSubtitle)
        navigationSubtitle.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 11).isActive = true
        navigationSubtitle.leftAnchor.constraint(equalTo: leftAnchor, constant: contentMargin).isActive = true
        navigationSubtitle.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -contentMargin).isActive = true
        navigationSubtitle.text = planTitle
    }
    
    init(planTitle: String) {
        super.init(frame: .zero)
        setupCloseButton()
        setupNavigationTitle()
        setupNavigationSubtitle(planTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
