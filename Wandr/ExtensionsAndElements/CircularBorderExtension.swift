//
//  CircularBorderExtension.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/19/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

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

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }
    
    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }
    
    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}
