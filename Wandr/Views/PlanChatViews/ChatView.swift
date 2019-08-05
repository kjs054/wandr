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
    
    var messages = [Message]()
    
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        return layout
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: contentMargin, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func checkIfNextMessageIsFromSameUser(_ indexPath: IndexPath) -> Bool {
        if indexPath.row != messages.count - 1 && messages[indexPath.row].sender == messages[indexPath.row + 1].sender {
            return true
        } else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: messageId, for: indexPath) as! MessageCell
        if checkIfNextMessageIsFromSameUser(indexPath) {
            cell.doesBreakTheSenderChain = false
        } else {
            cell.doesBreakTheSenderChain = true
        }
        cell.message = messages[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch messages[indexPath.item].type {
        case .text:
            let estimatedCellSize = MessageCell.init(frame: CGRect(x: 0, y: 0, width: 250, height: 1000))
            estimatedCellSize.textView.text = self.messages[indexPath.item].content
            estimatedCellSize.layoutIfNeeded()
            let estimatedSize = estimatedCellSize.systemLayoutSizeFitting(CGSize(width: self.frame.width, height: 1000))
            return CGSize(width: self.frame.width * 0.95, height: estimatedSize.height)
        default:
            return CGSize(width: self.frame.width, height: 0)
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        delegate = self
        dataSource = self
        layer.cornerRadius = 30.0
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        backgroundColor = .white
        register(MessageCell.self, forCellWithReuseIdentifier: messageId)
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MessageCell: UICollectionViewCell {
    
    var bubbleConstraints: AnchoredConstraints!
    
    var nameLabelConstraints: AnchoredConstraints!
    
    fileprivate func setupBlueBubbleOnRight() {
        textView.textColor = .white
        bubbleContainer.backgroundColor = wandrBlue
        bubbleConstraints.leading?.isActive = false
        bubbleConstraints.trailing?.isActive = true
        nameLabelConstraints.trailing?.isActive = true
        nameLabelConstraints.leading?.isActive = false
    }
    
    fileprivate func setupGrayBubbleOnLeft() {
        textView.textColor = .black
        bubbleContainer.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        bubbleConstraints.trailing?.isActive = false
        bubbleConstraints.leading?.isActive = true
        nameLabelConstraints.trailing?.isActive = false
        nameLabelConstraints.leading?.isActive = true
    }
    
    var message: Message! {
        didSet {
            textView.text = message.content
            nameLabel.text = "\(message.sender.name) - \(message.timestamp.toTime())"
            if self.message.isFromCurrentLoggedInUser {
                self.setupBlueBubbleOnRight()
            } else {
                self.setupGrayBubbleOnLeft()
            }
        }
    }
    
    var doesBreakTheSenderChain: Bool! {
        didSet {
            if doesBreakTheSenderChain {
                nameLabel.isHidden = false
            } else {
                nameLabel.isHidden = true
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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Book", size: 10)
        return label
    }()
    
    let bubbleContainer: UIView = {
        let bc = UIView()
        bc.layer.cornerRadius = 20
        return bc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBubbleContainer()
        setupNameLabel()
    }
    
    fileprivate func setupBubbleContainer() {
        bubbleContainer.transform = CGAffineTransform(scaleX: 1, y: -1)
        addSubview(bubbleContainer)
        bubbleConstraints = bubbleContainer.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        bubbleContainer.addSubview(textView)
        textView.fillSuperView(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    fileprivate func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.transform = CGAffineTransform(scaleX: 1, y: -1)
        nameLabelConstraints = nameLabel.anchor(top: bubbleContainer.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor)
        nameLabelConstraints.leading?.constant = 5
        nameLabelConstraints.trailing?.constant = -5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
