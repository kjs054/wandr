//
//  filtersView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

protocol categorySelectionDelegate {
    func updateNavTitle(_ categoryName: String)
    func updateThingsToDo(_ categoryAlias: String)
    func showCategoryChildren(_ categoryAlias: String)
}

class categoryFiltersView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Variables
    let categoryCellId = "categoryCellId"
    
    var selectionDelegate: categorySelectionDelegate?
    
    var reusableDataSource: SectionedCollectionViewDataSource?
    
    var parentCategory: PlaceCategory?
    
    var categories: [PlaceCategory]! {
        didSet {
            if parentCategory != nil {
                reusableDataSource = SectionedCollectionViewDataSource(dataSources: [CollectionViewDataSource.makeButtonCell(), CollectionViewDataSource.make(for: categories)])
            } else {
                 reusableDataSource = SectionedCollectionViewDataSource(dataSources: [CollectionViewDataSource.make(for: categories)])
            }
            dataSource = reusableDataSource
        }
    }
    
    //MARK:- Elements
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 100, height: 35)
        return layout
    }()
    
    //MARK:- View Setup
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        delegate = self
        register(filterCell.self, forCellWithReuseIdentifier: "placeCategory")
        register(previousCategoriesCell.self, forCellWithReuseIdentifier: "button")
        showsHorizontalScrollIndicator = false
        contentInset = UIEdgeInsets(top: 0, left: contentMargin, bottom: 0, right: 0)
    }
    
    //MARK:- CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if parentCategory != nil && indexPath.section == 0 {
            selectionDelegate?.showCategoryChildren(parentCategory!.parent)
        } else {
            let selectedCategory = categories[indexPath.row]
            if selectedCategory.selected {
                categories.forEach({$0.selected = false})
                selectionDelegate?.updateNavTitle("")
                selectionDelegate?.updateThingsToDo(selectedCategory.parent)
            } else {
                categories.forEach({$0.selected = false})
                categories[indexPath.item].selected = true
                selectionDelegate?.updateNavTitle("\(selectedCategory.emoji) \(selectedCategory.title)")
                selectionDelegate?.updateThingsToDo(selectedCategory.alias)
                selectionDelegate?.showCategoryChildren(selectedCategory.alias)
            }
            reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class previousCategoriesCell: UICollectionViewCell {
    let backButton: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "leftArrow"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addShadow()
        layer.cornerRadius = frame.height / 2
        setupBackButton()
    }
    
    func setupBackButton() {
        contentView.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 9).isActive = true
        backButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -11).isActive = true
        backButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
