//
//  Transitions.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/13/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

let transitionDuration: Double = 0.3
extension CATransition {
    
    func pushTransition(direction: CATransitionSubtype) -> CATransition {
        self.duration = transitionDuration
        self.type = CATransitionType.push
        self.subtype = direction
        self.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        return self
    }
    
    func moveInTransition(direction: CATransitionSubtype) -> CATransition {
        self.duration = transitionDuration
        self.type = CATransitionType.moveIn
        self.subtype = direction
        self.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        return self
    }
}
