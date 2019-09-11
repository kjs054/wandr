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
            backgroundColor = category.selected ? UIColor.mainBlue : .white
            textLabel.textColor = category.selected ? UIColor.white : .customGrey
            textLabel.text = "\(category.emoji) \(category.title)"
        }
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.customGrey
        label.textAlignment = .center
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
        contentView.addSubview(textLabel)
        textLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        textLabel.font = UIFont(name: "Avenir-Heavy", size: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
