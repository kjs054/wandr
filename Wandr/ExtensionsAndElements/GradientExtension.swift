//
//  GradientExtension.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/7/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setGradientBackground(colorRight: UIColor, colorLeft: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorRight.cgColor, colorLeft.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIViewController {
    func presentOnRoot(`with` viewController : UIViewController){
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
}
