//
//  CardBottom.swift
//  Wandr
//
//  Created by kevin on 5/31/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class CardBottom: UIView {
    let informationButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.red
        return button
    }()
    let tagsCollection: UICollectionView = {
        let tags = UICollectionView()
        return tags
    }()
    let operatingStatusLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let commentsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpBottomCard()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpBottomCard() {
        informationButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
}
