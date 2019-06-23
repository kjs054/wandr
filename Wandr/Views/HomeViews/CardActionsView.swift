//
//  HomeActionsStackView.swift
//  Wandr
//
//  Created by kevin on 6/1/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

//Bottom bar of buttons on home page
class CardActionsView: UIStackView {
    
    let navigateButton = actionButton(type: .system)
    
    let sendPlanButton = actionButton(type: .system)
    
    let likeButton = actionButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let buttonImages = ["navigateIcon", "sendPlan", "likeIcon"].map { (imageName) -> UIImage in
            let img = UIImage(named: imageName)!.withRenderingMode(.alwaysOriginal)
            return img
        }
        
        navigateButton.setImage(buttonImages[0] , for: .normal)
        navigateButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.24).isActive = true
        sendPlanButton.setImage(buttonImages[1], for: .normal)
        likeButton.setImage(buttonImages[2], for: .normal)
        likeButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.24).isActive = true
        let buttons = [navigateButton, sendPlanButton, likeButton]
        
        buttons.forEach { (v) in //add buttons to the self
            addArrangedSubview(v)
        }
        
        axis = .horizontal; isLayoutMarginsRelativeArrangement = true
        let marginSize = UIScreen.main.bounds.width * 0.1 //Future Dynamic
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: marginSize, bottom: 0, trailing: marginSize)
        heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true //Future Dynamic
    }
    
    required init(coder: NSCoder) {
        fatalError("Error")
    }
}
