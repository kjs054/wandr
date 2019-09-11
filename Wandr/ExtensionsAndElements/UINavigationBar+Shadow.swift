//
//  UINavigationBar+Shadow.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/25/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func addShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.1
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        layer.shadowColor = UIColor.black.cgColor
    }
}
