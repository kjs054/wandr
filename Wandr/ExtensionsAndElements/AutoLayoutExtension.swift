//
//  UIElements.swift
//  Wandr
//
//  Created by kevin on 5/31/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit


extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
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
