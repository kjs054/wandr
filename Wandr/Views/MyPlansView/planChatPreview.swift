//
//  myPlanChatCellCollectionViewCell.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/5/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

//
//  ContactView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/12/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import Kingfisher

class planChatPreview: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var members: [User]! {
        didSet {
            self.membersDataSource = .make(for: members, reuseIdentifier: memberImageCellId)
            profileImageCollection.dataSource = membersDataSource
            profileImageCollection.reloadData()
        }
    }
    
    let memberImageCellId = "memberCell"
    
    var membersDataSource: CollectionViewDataSource<User>?
    
    //MARK:- Elements
    let profileImageCollection: UICollectionView = {
        let flowLayout = FlowLayout()
        flowLayout.minimumInteritemSpacing = -12
        let pic = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        pic.translatesAutoresizingMaskIntoConstraints = false
        pic.backgroundColor = .clear
        return pic
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.textColor = UIColor.mainBlue
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Medium", size: 15)
        label.textColor = UIColor.customGrey
        return label
    }()
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 15)
        label.textColor = UIColor.customGrey
        label.textAlignment = .right
        return label
    }()
    
    //MARK:- View Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        profileImageCollection.contentInsetAdjustmentBehavior = .always
        isUserInteractionEnabled = false
        profileImageCollection.delegate = self
        profileImageCollection.register(userBubbleCell.self, forCellWithReuseIdentifier: memberImageCellId)
        setupProfileImageView()
        setupTitle()
        setupTimeStamp()
        setupSubTitle()
    }
    
    //Static Element Functions
    func setupProfileImageView() {
        addSubview(profileImageCollection)
        profileImageCollection.leftAnchor.constraint(equalTo: leftAnchor, constant: contentMargin).isActive = true
        profileImageCollection.heightAnchor.constraint(equalToConstant: 75).isActive = true
        profileImageCollection.widthAnchor.constraint(equalTo: profileImageCollection.heightAnchor).isActive = true
        profileImageCollection.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func setupTitle() {
        addSubview(title)
        title.leftAnchor.constraint(equalTo: profileImageCollection.rightAnchor, constant: 15).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -contentMargin).isActive = true
        title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -11).isActive = true
    }
    
    func setupSubTitle() {
        addSubview(subTitle)
        subTitle.anchor(top: title.bottomAnchor, bottom: nil, leading: profileImageCollection.trailingAnchor, trailing: timeStamp.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 25, right: 15))
    }
    
    func setupTimeStamp() {
        addSubview(timeStamp)
        timeStamp.anchor(top: title.bottomAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: contentMargin))
    }
    
    //MARK:- Logic
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func radioButtonClicked(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if members.count == 2 {
            return CGSize(width: 40, height: 40)
        }
        if members.count > 2 {
            return CGSize(width: 36, height: 36)
        }
        return CGSize(width: 64, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -12
    }
  
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if members.count == 1 {
            return UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        }
        if members.count == 2 {
            return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        }
    }
}
