//
//  filtersView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class filtersView: UIStackView {
    
    let searchBarView = UIView()
    
    let searchBar: UITextField = {
        let textField = UITextField()
        textField.layer.masksToBounds = false
        textField.attributedPlaceholder = NSAttributedString(string: "Find places, events and more", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customGrey])
        textField.layer.shadowRadius = 3.0
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.backgroundColor = .white
        textField.textColor = UIColor.customGrey
        textField.layer.shadowOffset = CGSize(width: 0, height: 0)
        textField.layer.shadowOpacity = 0.15
        textField.layer.cornerRadius = 18
        textField.font = UIFont(name: "Avenir-Heavy", size: 16)
        textField.leftViewMode = .always
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 18))
        leftImageView.contentMode = .scaleAspectFit
        textField.leftView = leftImageView
        leftImageView.image = UIImage(named: "search")
        let rightImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 20))
        rightImageView.contentMode = .scaleAspectFit
        textField.rightView = rightImageView
        textField.rightViewMode = .always
        rightImageView.image = UIImage(named: "filter")
        return textField
    }()
    
    let categoryFilters = categoryFiltersView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        searchBarView.addSubview(searchBar)
        searchBar.fillSuperView(padding: UIEdgeInsets(top: 0, left: contentMargin, bottom: 0, right: contentMargin))
        addArrangedSubview(searchBarView)
        addArrangedSubview(categoryFilters)
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillEqually
        setCustomSpacing(12, after: searchBarView) //future dynamic
        axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
