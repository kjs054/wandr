//
//  filtersView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class membersView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Variables
    let memberCellId = "member"
    let addMemberCellId = "addMember"
    
    var users = [SelectableContact]()
    
    //MARK:- Subviews
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 //TODO:- future dynamic
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let toLabel: UILabel = {
        let label = UILabel()
        label.text = "To:"
        label.textColor = wandrBlue
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Avenir-Heavy", size: 22)
        return label
    }()
    
    //MARK:- View Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(membersCell.self, forCellWithReuseIdentifier: memberCellId)
        addSubview(toLabel)
        toLabel.anchor(top: self.topAnchor, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
        toLabel.widthAnchor.constraint(equalToConstant: 25)
        addSubview(collectionView)
        collectionView.anchor(top: self.topAnchor, bottom: self.bottomAnchor, leading: toLabel.trailingAnchor, trailing: self.trailingAnchor)
    }
    
    //MARK:- CollectionView Functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    var selectedIndex: Int = -1
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memberCellId, for: indexPath) as! membersCell
        cell.userImage.loadImageWithCacheFromURLString(urlstring: users[indexPath.row].userData!.profileImageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.height * 0.8, height: frame.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}

class membersCell: UICollectionViewCell {
    
    let userImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = frame.height / 2
        backgroundView = userImage
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


