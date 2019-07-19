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
        place(title: "Autobahn Indoor Speedway", category: "🏎 Go-Kart Track", city: "Jessup, MD", distance: 3.8, pricing: Pricing.high, placeImages: ["dummyPlace"], savesCount: 23, operatingStatus: "Open", operatingStatusMessage: "until 11pm", commentCount: 19, rating: 4.2, numberOfRatings: 231),
        event(name: "All American Beer Festival 2019 at The Navy Yard", city: "District of Columbia", distance: 34, cover_photo: "coverevent", date: "Aug 8", start_time: "12:00", end_time: "10:00 PM", ticket_pricing: "$0-$25", attending_count: 433),
        place(title: "Grilled Cheese Co.", category: "🍽 Restaurant", city: "Catonsville, MD", distance: 8.8, pricing: Pricing.low, placeImages: ["grilledCheese","grilledCheese2","grilledCheese3"], savesCount: 122, operatingStatus: "Closed", operatingStatusMessage: "until 6am", commentCount: 12, rating: 3.1, numberOfRatings: 65),
        place(title: "Loch Raven Resevoir", category: "🏊‍♂️ Resevoir", city: "Phoenix, MD", distance: 2.1, pricing: Pricing.free, placeImages: ["lochRaven", "resevoir2", "resevoir3"], savesCount: 34, operatingStatus: "Open", operatingStatusMessage: "24/7", commentCount: 4, rating: 3.5, numberOfRatings: 98),
        place(title: "The Filling Station", category: "☕️ Coffee Shop", city: "Sparks Glencoe, MD", distance: 0.5, pricing: Pricing.low, placeImages: ["fillingstation1", "fillingstation2", "fillingstation3", "fillingstation4"], savesCount: 21, operatingStatus: "Open", operatingStatusMessage: "Closing at 11", commentCount: 5, rating: 4.7, numberOfRatings: 122)
        ] as [ProducesCardViewModel]
    
    let viewModels = producers.map({return $0.toCardViewModel()})
    return viewModels
}()

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    var placeImages: [String]
    var headerText: NSAttributedString
    var topRowText: NSAttributedString
    var bottomRowText: NSAttributedString
    
    init(placeImages: [String], headerText: NSAttributedString, topRowText: NSAttributedString, bottomRowText: NSAttributedString) {
        self.placeImages = placeImages; self.headerText = headerText; self.topRowText = topRowText; self.bottomRowText = bottomRowText;
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

