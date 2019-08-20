//
//  ReusableCollectionView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/18/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class CollectionViewDataSource<Model>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        cellConfigurator(model, cell)
        
        return cell
    }
    
    typealias CellConfigurator = (Model, UICollectionViewCell) -> Void
    
    var models: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
}

extension CollectionViewDataSource where Model == CardViewModel {
    static func make(for card: [CardViewModel], reuseIdentifier: String = "card") -> CollectionViewDataSource {
        return CollectionViewDataSource(models: card, reuseIdentifier: reuseIdentifier) { (data, cell) in
            let itemCell: cardCell = cell as! cardCell
            itemCell.cardView.cardViewModel = data
        }
    }
}

extension CollectionViewDataSource where Model == PlaceCategory {
    static func make(for categories: [PlaceCategory],
                     reuseIdentifier: String = "placeCategory") -> CollectionViewDataSource {
        return CollectionViewDataSource(models: categories, reuseIdentifier: reuseIdentifier) { (data, cell) in
            let itemCell: filterCell = cell as! filterCell
            itemCell.category = data
        }
    }
}

extension CollectionViewDataSource where Model == User {
    static func make(for users: [User],
                     reuseIdentifier: String = "users") -> CollectionViewDataSource {
        return CollectionViewDataSource(models: users, reuseIdentifier: reuseIdentifier) { (data, cell) in
            let itemCell: userBubbleCell = cell as! userBubbleCell
            itemCell.user = data
        }
    }
}


