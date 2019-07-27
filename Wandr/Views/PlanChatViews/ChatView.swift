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
    
    fileprivate let messages: [Message]
    
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
    
    init(messages: [Message]) {
        self.messages = messages
        super.init(frame: .zero, collectionViewLayout: flowLayout)
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
    
    fileprivate func setupBlueBubbleOnRight() {
        textView.textColor = .white
        bubbleContainer.backgroundColor = wandrBlue
        sentUserImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        bubbleContainer.trailingAnchor.constraint(equalTo: sentUserImage.leadingAnchor).isActive = true
    }
    
    fileprivate func setupGrayBubbleOnLeft() {
        textView.textColor = .black
        bubbleContainer.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        sentUserImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        bubbleContainer.leadingAnchor.constraint(equalTo: sentUserImage.trailingAnchor).isActive = true
    }
    
    fileprivate func checkIfSenderIsCurrentUser() {
        if message.sender.uid == LocalStorage().currentUserData()!["uid"] as! String {
            setupBlueBubbleOnRight()
        } else {
            setupGrayBubbleOnLeft()
        }
    }
    
    var message: Message! {
        didSet {
            checkIfSenderIsCurrentUser()
            textView.text = message.content
            sentUserImage.isHidden = true
            sentUserImage.loadImageWithCacheFromURLString(urlstring: message.sender.profileImageURL) {
                self.sentUserImage.isHidden = false
            }
        }
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.font = UIFont(name: "Avenir-Medium", size: 17)
        tv.backgroundColor = .clear
        return tv
    }()
    
    let sentUserImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }()
    
    let bubbleContainer: UIView = {
        let bc = UIView()
        bc.layer.cornerRadius = 20
        return bc
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        bubbleContainer.transform = CGAffineTransform(scaleX: 1, y: -1)
        sentUserImage.transform = CGAffineTransform(scaleX: 1, y: -1)
        addSubview(bubbleContainer)
        addSubview(sentUserImage)
        sentUserImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sentUserImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sentUserImage.heightAnchor.constraint(equalTo: sentUserImage.widthAnchor).isActive = true
        bubbleContainer.anchor(top: topAnchor, bottom: bottomAnchor, leading: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10))
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        bubbleContainer.addSubview(textView)
        textView.fillSuperView(padding: UIEdgeInsets(top: 0, left: 10, bottom: -10, right: 10))
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
