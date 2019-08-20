//
//  FilterCellCollectionViewCell.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/18/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class filterCell: UICollectionViewCell {
    
    var category: PlaceCategory! {
        didSet {
            let cellBackgroundColor = category.selected ? UIColor.mainBlue : .white
            backgroundColor = cellBackgroundColor
            textLabel.text = category.categoryEmoji
        }
    }
    
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.mainBlue
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addShadow()
        layer.cornerRadius = frame.height / 2
        setupTextLabel()
    }
    
    func setupTextLabel() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: frame.height).isActive = true
        textLabel.font = UIFont(name: "Avenir-Heavy", size: frame.height * 0.45)
        contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
