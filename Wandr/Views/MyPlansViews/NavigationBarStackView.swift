////
////  NavigationBarStackView.swift
////  Wandr
////
////  Created by kevin on 6/1/19.
////  Copyright © 2019 Wandr Inc. All rights reserved.
////
//
//import UIKit
//
////Sets properties for top navigation bar on home page
//class NavigationBarStackView: UIStackView {
//    let backButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(#imageLiteral(resourceName: "leftArrow").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        return button
//    }()
//    let fillSpaceButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    let title: UILabel = {
//        let label = UILabel()
//        label.text = "My Plans"
//        label.font = UIFont(name: "NexaBold", size: 23)
//        label.textColor = #colorLiteral(red: 0, green: 0.6588235294, blue: 1, alpha: 1)
//        return label
//    }()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        fillSpaceButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.1).isActive = true
//        backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor, multiplier: 0.7).isActive = true
//        let subviews = [backButton, title, fillSpaceButton]
//        subviews.forEach { (v) in //loop through subviews array adding them to the self
//            addArrangedSubview(v)
//        }
//        axis = .horizontal
//        distribution = .equalCentering
//        isLayoutMarginsRelativeArrangement = true //allows custom margins
//        layoutMargins = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16) //sets margins Future Dynamic
//        heightAnchor.constraint(equalToConstant: 90).isActive = true //Future Dynamic
//    }
//    required init(coder: NSCoder) {
//        fatalError("error")
//    }
//}
