//
//  FriendsBubbles.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/11/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class membersBubblesCollection: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var cellSpacing: CGFloat!
    
    var members: [User]! {
        didSet {
            self.reusableDataSource = .make(for: members)
            dataSource = self.reusableDataSource
            self.cellSpacing = -(CGFloat(members.count) * 4.5)
            reloadData()
        }
    }
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    let friendCellId = "FriendCellId"
    
    var reusableDataSource: CollectionViewDataSource<User>?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        translatesAutoresizingMaskIntoConstraints = true
        delegate = self
        backgroundColor = .white
        isScrollEnabled = false
        register(userBubbleCell.self, forCellWithReuseIdentifier: "users")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

class userBubbleCell: UICollectionViewCell {
    
    let profileImage = UIImageView()
    
    
    var user: User! {
        didSet {
            let memberImage = UIImageView()
            memberImage.setCachedImage(urlstring: user.profileImageURL, size: self.frame.size) {
                self.addSubview(memberImage)
                memberImage.fillSuperView()
                memberImage.centerInsideSuperView()
            }
            layer.addCircularBorder(size: frame.size, strokeColor: .white, lineWidth: 4)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

