//
//  Conversions.swift
//  Wandr
//
//  Created by Kevin Shiflett on 9/6/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation

extension Double {
    func truncate(places : Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
