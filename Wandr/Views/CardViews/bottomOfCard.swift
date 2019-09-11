//
//  bottomOfCard.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/7/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
class bottomOfCard: UIView {
    
    //MARK:- Elements
    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = UIColor.customDarkGrey
        label.font = UIFont(name: "Avenir-Heavy", size: 22)
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.customGrey
        label.font = UIFont(name: "Avenir-Heavy", size: 18)
        return label
    }()
    
    let planButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 400, height: 45))
        button.setGradientBackground(colorRight: .mainBlue, colorLeft: #colorLiteral(red: 0, green: 0.4235294118, blue: 1, alpha: 1))
        button.layer.cornerRadius = 22.5
        button.setTitle("Make Plan", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 18)
        button.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        button.titleLabel?.layer.shadowRadius = 3
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.titleLabel?.layer.shadowOpacity = 0.25
        button.layer.masksToBounds = true
        return button
    }()
    
    //MARK:- Setup View
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = cardCornerRadius
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeaderContent() {
        mainStackView.removeAllArrangedSubviews()
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.distribution = .fillProportionally
        titleLabel.preferredMaxLayoutWidth = mainStackView.bounds.width - 65
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(distanceLabel)
        mainStackView.addArrangedSubview(headerStack)
        mainStackView.setCustomSpacing(20, after: headerStack)
    }
    
    func setupDetailsStacks(content: [[String: String]]) {
        setupHeaderContent()
        content.forEach { (rowContent) in
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillProportionally
            mainStackView.addArrangedSubview(stackView)
            mainStackView.setCustomSpacing(20, after: stackView)
            for (key, value) in rowContent.sorted(by: { $0.0 > $1.0 }) {
                let cardItemButton = UIButton()
                cardItemButton.setTitle(value, for: .normal)
                cardItemButton.layer.shadowColor = UIColor.black.cgColor
                cardItemButton.layer.shadowRadius = 2.5
                cardItemButton.layer.shadowOffset = CGSize(width: 0, height: 0)
                cardItemButton.layer.shadowOpacity = 0.15
                cardItemButton.backgroundColor = .white
                cardItemButton.layer.cornerRadius = 17
                switch key {
                case "operatingStatus":
                    cardItemButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
                    cardItemButton.setTitleColor(value == "Open" ? UIColor.customGreen : UIColor.customRed, for: .normal)
                default:
                    cardItemButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
                    cardItemButton.setTitleColor(.customGrey, for: .normal)
                }
                stackView.addArrangedSubview(cardItemButton)
                stackView.setCustomSpacing(10, after: cardItemButton)
            }
        }
        addSubview(mainStackView)
        mainStackView.fillSuperView(padding: UIEdgeInsets(top: 25, left: contentMargin, bottom: contentMargin, right: contentMargin))
        setupPlanButton()
    }
    
    func setupPlanButton() {
        mainStackView.addArrangedSubview(planButton)
        planButton.translatesAutoresizingMaskIntoConstraints = false
        planButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
