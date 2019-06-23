//
//  RoundedButton.swift
//  Wandr
//
//  Created by kevin on 6/1/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

let wandrBlue: UIColor = #colorLiteral(red: 0, green: 0.6588235294, blue: 1, alpha: 1)

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = bounds.size.width / 2.0
        layer.cornerRadius = radius
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.masksToBounds = false
        backgroundColor = UIColor.white
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

class circularButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = bounds.size.width / 2.0
        layer.cornerRadius = radius
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.masksToBounds = true
        imageView?.contentMode = .scaleAspectFill
        backgroundColor = wandrBlue
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

class actionButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        translatesAutoresizingMaskIntoConstraints = false 
        imageView?.contentMode = .scaleAspectFit
    }
}

class infoBubble: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = frame.height/2
        layer.masksToBounds = true
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
