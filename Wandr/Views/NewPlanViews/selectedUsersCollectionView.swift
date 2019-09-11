//
//  filtersView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class selectedUsersCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK:- Variables
    let memberCellId = "member"
    let addMemberCellId = "addMember"
    
    var users = [SelectableContact]() {
        didSet {
            self.reusableDataSource = .make(for: users, reuseIdentifier: memberCellId)
            dataSource = reusableDataSource
        }
    }
    
    var reusableDataSource: CollectionViewDataSource<SelectableContact>?
    
    //MARK:- Subviews
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 //TODO:- future dynamic
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 100, height: 35)
        return layout
    }()
    
    //MARK:- View Setup
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        self.backgroundColor = .white
        register(membersCell.self, forCellWithReuseIdentifier: memberCellId)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}

class membersCell: UICollectionViewCell {
    
    var contact: SelectableContact! {
        didSet {
            userName.text = contact.name
        }
    }
    
    let userName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 15)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = frame.height / 2
        backgroundColor = UIColor.mainBlue
        addSubview(userName)
        userName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userName.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        userName.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


