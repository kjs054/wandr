//
//  CardViewModel.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    var placeImages: [String]
    var detailsContent: [[String: String]]
    var headerContent: [String: String]
    var extraContent: [String: String]?
    
    init(placeImages: [String], headerContent: [String: String], detailsContent: [[String: String]]) {
        self.placeImages = placeImages; self.headerContent = headerContent; self.detailsContent = detailsContent
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageName = placeImages[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image)
        }
    }
    
    var imageIndexObserver: ((Int,UIImage?) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = imageIndex == placeImages.count - 1 ? 0 : (imageIndex+1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = imageIndex == 0 ? placeImages.count - 1 : (imageIndex-1)
    }
}

