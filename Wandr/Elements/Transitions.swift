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
    
    func fromLeft() -> CATransition {
        self.duration = transitionDuration
        self.type = CATransitionType.push
        self.subtype = CATransitionSubtype.fromLeft
        self.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        return self
    }
    
    func fromRight() -> CATransition {
        self.duration = transitionDuration
        self.type = CATransitionType.push
        self.subtype = CATransitionSubtype.fromRight
        self.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        return self
    }
    
    func fromTop() -> CATransition {
        self.duration = transitionDuration
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromBottom
        self.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        return self
    }
    
    func fromBottom() -> CATransition {
        self.duration = transitionDuration
        self.type = CATransitionType.moveIn
        self.subtype = CATransitionSubtype.fromTop
        self.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        return self
    }
}
