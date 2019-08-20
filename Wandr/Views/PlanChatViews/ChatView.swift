//
//  ChatView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/25/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

protocol MessageDelegate {
    func showMessageActionMenu(message: Message)
}

class ChatView: UICollectionView {
        
    let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        layout.minimumLineSpacing = 10
        return layout
    }()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        backgroundColor = .white
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatInfoCell: UICollectionViewCell {
    
    var message: Message! {
        didSet {
            informationLabel.text = message.getDisplayText()
        }
    }
    
    let informationLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        label.textColor = UIColor.customGrey
        label.transform = CGAffineTransform(scaleX: 1, y: -1)
        label.font = UIFont(name: "Avenir-Medium", size: 13)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(informationLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MessageCell: UICollectionViewCell {
    
    var bubbleConstraints: AnchoredConstraints!
    
    var colorIndicatorConstraints: AnchoredConstraints!
    
    var profileImageConstraints: AnchoredConstraints!
    
    var nameLabelConstraints: AnchoredConstraints!
    
    fileprivate func setupBlueBubbleOnRight() {
        textView.textColor = #colorLiteral(red: 0.1455054283, green: 0.1505178213, blue: 0.1479265988, alpha: 1)
        nameLabel.textColor = UIColor.customGrey
        leftColorIndicator.backgroundColor = UIColor.mainBlue
        bubbleConstraints.leading?.isActive = false
        bubbleConstraints.trailing?.isActive = true
        nameLabelConstraints.trailing?.isActive = true
        nameLabelConstraints.leading?.isActive = false
        colorIndicatorConstraints.leading?.isActive = false
        colorIndicatorConstraints.trailing?.isActive = true
        profileImageConstraints.trailing?.isActive = true
        profileImageConstraints.leading?.isActive = false
        textView.textAlignment = .right
    }
    
    fileprivate func setupGrayBubbleOnLeft() {
        textView.textColor = #colorLiteral(red: 0.1455054283, green: 0.1505178213, blue: 0.1479265988, alpha: 1)
        nameLabel.textColor = UIColor.customGrey
        leftColorIndicator.backgroundColor = self.message.sender.displayColor
        colorIndicatorConstraints.leading?.isActive = true
        colorIndicatorConstraints.trailing?.isActive = false
        bubbleConstraints.trailing?.isActive = false
        bubbleConstraints.leading?.isActive = true
        profileImageConstraints.trailing?.isActive = false
        profileImageConstraints.leading?.isActive = true
        nameLabelConstraints.trailing?.isActive = false
        nameLabelConstraints.leading?.isActive = true
        textView.textAlignment = .left
    }
    
    var messageDelegate: MessageDelegate!
    
    var message: Message! {
        didSet {
            textView.text = message.content
            nameLabel.text = "\(message.sender.name) - \(message.timestamp.toTime())"
            profileImage.setImage(urlstring: message.sender.profileImageURL, size: CGSize(width: 35, height: 35), complete: {})
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
                profileImage.isHidden = false
                self.bubbleConstraints.bottom?.constant = 0
            } else {
                nameLabel.isHidden = true
                profileImage.isHidden = true
                self.bubbleConstraints.bottom?.constant = 14
            }
        }
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = false
        tv.font = UIFont(name: "Avenir-Medium", size: 17)
        tv.backgroundColor = .clear
        return tv
    }()
    
    let profileImage: circularImageView = {
        let civ = circularImageView()
        civ.transform = CGAffineTransform(scaleX: 1, y: -1)
        return civ
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.transform = CGAffineTransform(scaleX: 1, y: -1)
        label.font = UIFont(name: "Avenir-Book", size: 10)
        return label
    }()
    
    let leftColorIndicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        return view
    }()
    
    let bubbleContainer: UIView = {
        let bc = UIView()
        bc.transform = CGAffineTransform(scaleX: 1, y: -1)
        bc.layer.cornerRadius = 0
        bc.layer.masksToBounds = true
        return bc
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileImage()
        setupColorIndicator()
        setupNameLabel()
        setupBubbleContainer()
        setupMenuLongPressGesture()
    }
    
    override func layoutIfNeeded() {
        bubbleConstraints.leading?.constant = 35
        bubbleConstraints.trailing?.constant = -35
    }
    
    fileprivate func setupProfileImage() {
        addSubview(profileImage)
        profileImageConstraints = profileImage.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 6, right: 10))
        profileImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
    }
    
    fileprivate func setupColorIndicator() {
        addSubview(leftColorIndicator)
        colorIndicatorConstraints = leftColorIndicator.anchor(top: topAnchor, bottom: bottomAnchor, leading: profileImage.trailingAnchor, trailing: profileImage.leadingAnchor)
        colorIndicatorConstraints.leading?.constant = 5
        colorIndicatorConstraints.trailing?.constant = -5
        leftColorIndicator.widthAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    fileprivate func setupBubbleContainer() {
        addSubview(bubbleContainer)
        bubbleConstraints = bubbleContainer.anchor(top: topAnchor, bottom: nameLabel.topAnchor, leading: leftColorIndicator.trailingAnchor, trailing: leftColorIndicator.leadingAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.70).isActive = true
        bubbleContainer.addSubview(textView)
        textView.fillSuperView(padding: UIEdgeInsets(top: -5, left: 5, bottom: -5, right: 5))
    }
    
    fileprivate func setupNameLabel() {
        addSubview(nameLabel)
        nameLabelConstraints = nameLabel.anchor(top: nil, bottom: bottomAnchor, leading: leftColorIndicator.trailingAnchor, trailing: leftColorIndicator.leadingAnchor)
        nameLabelConstraints.leading?.constant = 5
        nameLabelConstraints.trailing?.constant = -5
    }
    
    func setupMenuLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleChatLongPressGesture))
        addGestureRecognizer(gesture)
    }
    
    @objc func handleChatLongPressGesture() {
        self.messageDelegate.showMessageActionMenu(message: self.message)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
