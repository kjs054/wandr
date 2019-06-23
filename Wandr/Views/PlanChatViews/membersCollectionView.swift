//
//  CollectionViewController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/15/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

private let memberCellId = "memberCell"

class membersCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.setCollectionViewLayout(flowLayout, animated: false)
        collectionView!.register(memberCell.self, forCellWithReuseIdentifier: memberCellId)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memberCellId, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 15, height: 15)
    }
}

class memberCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
