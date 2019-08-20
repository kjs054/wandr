//
//  SlideInPresentationManager.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

enum PresentationDirection {
    case left
    case top
    case right
    case bottom
}

class SlideInPresentationManager: NSObject {
    var direction: PresentationDirection = .left
}

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
        ) -> UIPresentationController? {
        let presentationController = SlideInPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            direction: direction
        )
        return presentationController
    }
}
