//
//  activityIndicatorView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/24/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class activityIndicatorView: UIView {
    
    let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.startAnimating()
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    let activityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Avenir-Heavy", size: 21)
        return label
    }()
    
    init(color: UIColor, labelText: String) {
        super.init(frame: .zero)
        let contentColor = color == .white ? UIColor.mainBlue : .white
        activityIndicator.color = contentColor
        activityLabel.textColor = contentColor
        backgroundColor = color
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -21).isActive = true
        addSubview(activityLabel)
        activityLabel.text = labelText
        activityLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityLabel.centerYAnchor.constraint(equalTo: centerYAnchor,constant: 21).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
