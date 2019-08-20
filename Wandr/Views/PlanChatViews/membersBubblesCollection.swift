//
//  FriendsBubbles.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/11/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class membersBubblesCollection: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var members: [User]! {
        didSet {
            members.removeAll(where: {$0.name == LocalStorage().currentUserData()?.name})
            self.reusableDataSource = .make(for: members)
            dataSource = self.reusableDataSource
            reloadData()
        }
    }
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = -10
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
        setupShadow()
    }
    
    fileprivate func setupShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.1
        layer.shadowColor = UIColor.black.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalCellWidth = 45 * Double(members.count)
        let totalCellSpacing = -(Double(10 * members.count))
        
        let leftInset = (UIScreen.main.bounds.width - CGFloat(totalCellWidth + totalCellSpacing)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsets(top: -4, left: leftInset, bottom: 0, right: rightInset)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.height * 0.85, height: self.frame.height * 0.85)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class userBubbleCell: UICollectionViewCell {
    
    let profileImage = UIImageView()
    
    
    var user: User! {
        didSet {
            self.isHidden = true
            profileImage.setImage(urlstring: user.profileImageURL, size: profileImage.frame.size) {
                self.backgroundView = self.profileImage
                self.layer.addCircularBorder(size: self.frame.size, strokeColor: self.user.displayColor!, lineWidth: 11)
                self.layer.addCircularBorder(size: self.frame.size, strokeColor: .white, lineWidth: 7)
                self.isHidden = false
            }
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

