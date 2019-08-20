//
//  RoundedButton.swift
//  Wandr
//
//  Created by kevin on 6/1/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = bounds.size.width / 2.0
        layer.cornerRadius = radius
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.masksToBounds = true
        imageView?.contentMode = .scaleAspectFill
        backgroundColor = UIColor.white
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

class circularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = bounds.size.width / 2.0
        layer.cornerRadius = radius
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.masksToBounds = true
        contentMode = .scaleAspectFill
        backgroundColor = UIColor.mainBlue
    }
}

class circularView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = bounds.size.width / 2.0
        layer.cornerRadius = radius
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.masksToBounds = true
        backgroundColor = UIColor.mainBlue
    }
}

class LoginAndRegisterTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        font = UIFont(name: "Avenir-Heavy", size: 22)
        autocorrectionType = .no
        adjustsFontSizeToFitWidth = true
        textColor = UIColor.mainBlue
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = 18
        translatesAutoresizingMaskIntoConstraints = false
    }
}

class LoginAndRegisterInfoLabel: UILabel {
    override func layoutSubviews() {
        super.layoutSubviews()
        font = UIFont(name: "NexaBold", size: 25)
        adjustsFontSizeToFitWidth = true
        textColor = .white
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
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
        layer.shadowColor = UIColor.black.cgColor
    }
}
