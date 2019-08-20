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
}

class categoryFiltersView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Variables
    var rankedFilters = categoryFilters.sorted(by: {$0.recWeight > $1.recWeight}) //Sorts by recommendation ranking
    
    let categoryCellId = "categoryCellId"
    
    var selectionDelegate: categorySelectionDelegate?
    
    var reusableDataSource: CollectionViewDataSource<PlaceCategory>?
    
    //MARK:- Elements
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15 //future dynamic
        return layout
    }()
    
    //MARK:- View Setup
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        setupCollectionView()
    }
    
    func setupCollectionView() {
        delegate = self
        register(filterCell.self, forCellWithReuseIdentifier: "placeCategory")
        reusableDataSource = .make(for: rankedFilters)
        dataSource = reusableDataSource
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
    
    //MARK:- CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if rankedFilters[indexPath.item].selected {
            rankedFilters.forEach({$0.selected = false})
            selectionDelegate?.updateNavTitle("")
        } else {
            rankedFilters.forEach({$0.selected = false})
            rankedFilters[indexPath.item].selected = true
            let selectedCategory = rankedFilters[indexPath.row].categoryName
            selectionDelegate?.updateNavTitle(selectedCategory)
        }
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.height * 0.9, height: frame.height * 0.9)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
