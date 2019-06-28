//
//  planCell.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/13/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//
import UIKit

class planPreviewCell: UITableViewCell {
    
    let contactCellView = ContactView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contactCellView)
        contactCellView.setupTimeStamp()
        contactCellView.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
