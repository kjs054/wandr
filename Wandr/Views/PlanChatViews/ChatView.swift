//
//  ChatView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/25/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class ChatView: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate let messageId = "message"
    
    fileprivate var messages = ["Ok", "Sounds good I'll be here", "What is going on? What are we doing. I have a dentist appointment today at 6 so I cant wait too long! Im gonna die stop killing me with your procrastination you dicks"]
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        return layout
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageId, for: indexPath) as! MessageCell
        cell.textView.text = messages[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedCellSize = MessageCell.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 1000))
        estimatedCellSize.textView.text = self.messages[indexPath.item]
        estimatedCellSize.layoutIfNeeded()
        let estimatedSize = estimatedCellSize.systemLayoutSizeFitting(CGSize(width: self.frame.width, height: 1000))
        return CGSize(width: self.frame.width, height: estimatedSize.height + 10)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        delegate = self
        dataSource = self
        layer.cornerRadius = 30.0
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backgroundColor = .white
        register(MessageCell.self, forCellWithReuseIdentifier: messageId)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        tv.font = UIFont(name: "Avenir-Medium", size: 17)
        tv.backgroundColor = .clear
        return tv
    }()
    
    let bubbleContainer: UIView = {
        let bc = UIView()
        bc.layer.cornerRadius = 20
        bc.backgroundColor = wandrBlue
        return bc
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleContainer)
        bubbleContainer.anchor(top: topAnchor, bottom: bottomAnchor, leading: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: contentMargin, bottom: 0, right: -contentMargin))
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        bubbleContainer.addSubview(textView)
        textView.fillSuperView(padding: UIEdgeInsets(top: 0, left: 10, bottom: -10, right: 10))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
