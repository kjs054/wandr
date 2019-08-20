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
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.15
    }
}

extension CALayer {
    func addCircularBorder(size: CGSize, strokeColor: UIColor, lineWidth: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: ([.topLeft, .topRight, .bottomLeft, .bottomRight]), cornerRadii: size)
        let borderShape = CAShapeLayer.init()
        borderShape.path = maskPath.cgPath
        self.masksToBounds = true
        borderShape.fillColor = nil
        borderShape.strokeColor = strokeColor.cgColor
        borderShape.lineWidth = lineWidth
        addSublayer(borderShape)
    }
}
