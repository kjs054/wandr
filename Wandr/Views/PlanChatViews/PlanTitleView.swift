//
//  PlanTitleView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/20/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class PlanTitleView: UIView {
    
    var planName: String! {
        willSet {
        }
        didSet {
            self.planChatName.text = planName
            let totalCellWidth = 30 * CGFloat(members.count)
            let totalSpacing = -((CGFloat(members.count) * 4.5) * CGFloat(members.count - 1))
            var leftSpacing = 100 - ((totalCellWidth + totalSpacing) + 6.5)
            var rightSpacing = 100 - (planChatName.intrinsicContentSize.width + 6.5)
            if rightSpacing < 0 { rightSpacing = 0 }
            let spacingForEachSide = (leftSpacing + rightSpacing) / 2
            leftSpacing = leftSpacing - spacingForEachSide
            spacerView.frame = CGRect(x: ((self.frame.width / 2) - (self.frame.height / 2)) - leftSpacing, y: 0, width: 13, height: self.frame.height)
        }
    }
    
    var members: [User]! {
        didSet {
            members.removeAll(where: {$0.name == LocalStorage().currentUserData()?.name})
            let totalCellWidth = 30 * CGFloat(members.count)
            let totalSpacing = -((CGFloat(members.count) * 4.5) * CGFloat(members.count - 1))
            membersCollection.widthAnchor.constraint(equalToConstant: totalCellWidth + totalSpacing).isActive = true
            membersCollection.members = members
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 35)
    }

    let planChatName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Avenir-Heavy", size: 18)
        label.textColor = UIColor.mainBlue
        return label
    }()
    
    var spacerView = UIView()
    
    let membersCollection = membersBubblesCollection()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        addSubview(spacerView)
        addSubview(membersCollection)
        membersCollection.translatesAutoresizingMaskIntoConstraints = false
        membersCollection.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        membersCollection.heightAnchor.constraint(equalToConstant: 30).isActive = true
        membersCollection.rightAnchor.constraint(equalTo: spacerView.leftAnchor).isActive = true
        addSubview(planChatName)
        planChatName.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        planChatName.leftAnchor.constraint(equalTo: spacerView.rightAnchor).isActive = true
        planChatName.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
