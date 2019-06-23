//
//  filtersView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class filtersView: UIStackView {
    
    let tagsFilters = tagsFiltersView()
    
    let categoryFilters = categoryFiltersView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addArrangedSubview(tagsFilters)
        addArrangedSubview(categoryFilters)
        translatesAutoresizingMaskIntoConstraints = false
        distribution = .fillEqually
        setCustomSpacing(12, after: tagsFilters) //future dynamic
        axis = .vertical
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
