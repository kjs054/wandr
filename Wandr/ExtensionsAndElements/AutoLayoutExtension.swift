//
//  UIElements.swift
//  Wandr
//
//  Created by kevin on 5/31/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit


extension UIView {
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func fillSuperView(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let fillToTop = superview?.safeAreaLayoutGuide.topAnchor {
            topAnchor.constraint(equalTo: fillToTop, constant:  padding.top).isActive = true
        }
        if let fillToBottom = superview?.safeAreaLayoutGuide.bottomAnchor {
            bottomAnchor.constraint(equalTo: fillToBottom, constant: -(padding.bottom)).isActive = true
        }
        if let fillToLeft = superview?.safeAreaLayoutGuide.leadingAnchor {
            leadingAnchor.constraint(equalTo: fillToLeft, constant: padding.left).isActive = true
        }
        if let fillToRight = superview?.safeAreaLayoutGuide.trailingAnchor {
            trailingAnchor.constraint(equalTo: fillToRight, constant: -(padding.right)).isActive = true
        }
    }
    
    func centerInsideSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerX = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}
