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
        if let models = models {
            return models.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let models = models {
            let model = models[indexPath.row]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )
            
            cellConfigurator!(model, cell)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )
            return cell
        }
    }
    
    typealias CellConfigurator = ((Model?, UICollectionViewCell) -> Void)?
    
    var models: [Model]?
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model]? = nil, reuseIdentifier: String, cellConfigurator: CellConfigurator = nil) {
        if let models = models {
            self.models = models
        }
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
    
    static func makeButtonCell(reuseIdentifier: String = "button") -> CollectionViewDataSource {
        return CollectionViewDataSource(reuseIdentifier: reuseIdentifier)
    }
}

extension CollectionViewDataSource where Model == SelectableContact {
    static func make(for contacts: [SelectableContact],
                     reuseIdentifier: String = "selectableContact") -> CollectionViewDataSource {
        return CollectionViewDataSource(models: contacts, reuseIdentifier: reuseIdentifier) { (data, cell) in
            let itemCell: membersCell  = cell as! membersCell
            itemCell.contact = data
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

class SectionedCollectionViewDataSource: NSObject {
    private let dataSources: [UICollectionViewDataSource]
    
    init(dataSources: [UICollectionViewDataSource]) {
        self.dataSources = dataSources
    }
}

extension SectionedCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataSource = dataSources[section]
        return dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
        return dataSource.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSources.count
    }
}
