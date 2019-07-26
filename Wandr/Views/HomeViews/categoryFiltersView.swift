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

class categoryFiltersView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Variables
    let categoryCellId = "categoryCellId"
    
    var selectionDelegate: categorySelectionDelegate?
    
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
        dataSource = self
        register(filterCell.self, forCellWithReuseIdentifier: categoryCellId)
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
    
    //MARK:- CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == selectedIndex {
            selectedIndex = -1
            selectionDelegate?.updateNavTitle("")
        } else {
            selectedIndex = indexPath.row
            let selectedCategory = rankedFilters[indexPath.row].categoryName
            selectionDelegate?.updateNavTitle(selectedCategory)
        }
        reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryFilters.count
    }
    
    var selectedIndex: Int = -1
    
    let rankedFilters = categoryFilters.sorted(by: {$0.recWeight > $1.recWeight}) //Sorts by recommendation ranking
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! filterCell
        let cellBackgroundColor = selectedIndex == indexPath.row ? wandrBlue : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.backgroundColor = cellBackgroundColor
        cell.textLabel.text = rankedFilters[indexPath.row].categoryEmoji
        return cell
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
