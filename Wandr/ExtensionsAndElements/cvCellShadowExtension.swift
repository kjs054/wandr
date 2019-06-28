//
//  cvCellShadowExtension.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/22/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    func addShadow() {
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowRadius = 2.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.15
    }
}
