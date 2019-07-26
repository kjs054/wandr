//
//  filtersView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class tagsFiltersView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Variables
    let tagFilterId = "tagCellId"
    
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
        register(filterCell.self, forCellWithReuseIdentifier: tagFilterId)
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == selectedIndex { //checks to see if the selected row is selected index
            selectedIndex = -1 //nothing will be selected
        } else{
            selectedIndex = indexPath.row
        }
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeTagFilters.count
    }
    
    var selectedIndex: Int = -1
    let rankedTags = placeTagFilters.sorted(by: {$0.recWeight > $1.recWeight})
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagFilterId, for: indexPath) as! filterCell
        let backgroundColor = selectedIndex == indexPath.row ? wandrBlue : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let textColor = selectedIndex == indexPath.row ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : wandrBlue
        cell.backgroundColor = backgroundColor
        cell.textLabel.textColor = textColor
        cell.textLabel.text = rankedTags[indexPath.row].tagName
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.height * 0.8) * 3, height: frame.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
