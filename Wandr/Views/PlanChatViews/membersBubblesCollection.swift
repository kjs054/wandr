//
//  FriendsBubbles.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/11/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class membersBubblesCollection: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate let members: [User]
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        return layout
    }()
    
    let friendCellId = "FriendCellId"
    
    init(chatMembers: [User]) {
        self.members = chatMembers
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        translatesAutoresizingMaskIntoConstraints = true
        delegate = self
        dataSource = self
        layer.masksToBounds = false
        backgroundColor = .clear
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowRadius = 2.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.15
        register(friendCell.self, forCellWithReuseIdentifier: friendCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: friendCellId, for: indexPath) as! friendCell
        cell.user = members[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.height, height: self.frame.height)
    }
    
}

class friendCell: UICollectionViewCell {
    
    let profileImage = UIImageView()
    
    var user: User! {
        didSet {
            self.isHidden = true
            profileImage.loadImageWithCacheFromURLString(urlstring: user.profileImageURL) {
                self.backgroundView = self.profileImage
                self.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
