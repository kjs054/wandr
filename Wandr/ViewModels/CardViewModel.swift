//
//  CardViewModel.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/10/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

let cardViewModels: [CardViewModel] = {
    
    let producers = [
        place(title: "Autobahn Indoor Speedway", category: "🏎 Go-Kart Track", city: "Jessup, MD", distance: 3.8, minPrice: 25, maxPrice: 150, placeImages: ["dummyPlace"], savesCount: 23, operatingStatus: "Open", operatingStatusMessage: "until 11pm", commentCount: 19),
        place(title: "Grilled Cheese Co.", category: "🍽 Restaurant", city: "Catonsville, MD", distance: 8.8, minPrice: 7, maxPrice: 15, placeImages: ["grilledCheese","grilledCheese2","grilledCheese3"], savesCount: 122, operatingStatus: "Closed", operatingStatusMessage: "until 6am", commentCount: 12),
        place(title: "Loch Raven Resevoir", category: "🏊‍♂️ Resevoir", city: "Phoenix, MD", distance: 2.1, minPrice: 0, maxPrice: 0, placeImages: ["lochRaven", "resevoir2", "resevoir3"], savesCount: 34, operatingStatus: "Open", operatingStatusMessage: "24/7", commentCount: 4),
        place(title: "The Filling Station", category: "☕️ Coffee Shop", city: "Sparks Glencoe, MD", distance: 0.5, minPrice: 5, maxPrice: 12, placeImages: ["fillingstation1", "fillingstation2", "fillingstation3", "fillingstation4"], savesCount: 21, operatingStatus: "Open", operatingStatusMessage: "Closing at 11", commentCount: 5)
        ] as [ProducesCardViewModel]
    
    let viewModels = producers.map({return $0.toCardViewModel()})
    return viewModels
}()

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    var placeImages: [String]
    var headerAttributedString: NSAttributedString
    var category: String
    var minPrice: Int
    var maxPrice: Int
    var numOfSaves: Int
    var bottomAttributedString: NSAttributedString
    
    init(placeImages: [String], headerAttributedString: NSAttributedString, category: String, minPrice: Int, maxPrice: Int, numOfSaves: Int, bottomAttributedString: NSAttributedString) {
        self.placeImages = placeImages; self.headerAttributedString = headerAttributedString; self.category = category; self.minPrice = minPrice; self.maxPrice = maxPrice; self.numOfSaves = numOfSaves; self.bottomAttributedString = bottomAttributedString;
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

