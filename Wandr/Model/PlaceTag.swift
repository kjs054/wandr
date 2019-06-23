//
//  PlaceTag.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/18/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation
import UIKit
let placeTagFilters = [PlaceTag(tagName: "Cheap", tagId: 01, recWeight: 0.894),
                       PlaceTag(tagName: "Outdoor", tagId: 02, recWeight: 0.613),
                       PlaceTag(tagName: "Family", tagId: 03, recWeight: 0.259),
                       PlaceTag(tagName: "Popular", tagId: 04, recWeight: 0.994),
                       PlaceTag(tagName: "Healthy", tagId: 05, recWeight: 0.582),
                       PlaceTag(tagName: "Free", tagId: 06, recWeight: 0.721)]

class PlaceTag {
    var tagName: String
    var tagId: Int
    var recWeight: Double
    
    init(tagName: String, tagId: Int, recWeight: Double) {
        self.tagName = tagName; self.tagId = tagId; self.recWeight = recWeight
    }
    
    func selectTagFilter() {
        
    }
}
