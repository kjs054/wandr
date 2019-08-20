//
//  Place.swift
//  Wandr
//
//  Created by kevin on 6/6/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

struct Place: ProducesCardViewModel {
    //Defining properties
    var title: String
    var category: String
    var city: String
    var distance: Double
    var pricing: Pricing
    var placeImages: [String]
    var savesCount: Int
    var operatingStatus: String
    var operatingStatusMessage: String
    var commentCount: Int
    var rating: CGFloat
    var numberOfRatings: Int
    
    func toCardViewModel() -> CardViewModel {
        let headerText = NSMutableAttributedString(string: title, attributes: [.font: UIFont(name: "NexaBold", size: UIScreen.main.bounds.width / 17)!])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        headerText.append(NSAttributedString(string: "\n\(city) \u{2022} \(distance) mi", attributes: [.font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 20)!]))
        headerText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, headerText.length))
        let topRowText = NSMutableAttributedString(string: "\(category)", attributes: [.font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 22)!, .foregroundColor: UIColor.customGrey])
        let bottomRowText = NSMutableAttributedString(string: operatingStatus, attributes: [.font: UIFont(name: "Avenir-Black", size: UIScreen.main.bounds.width / 22)!])
        bottomRowText.addAttribute(NSAttributedString.Key.foregroundColor, value: getOperatingStatusColor(status: operatingStatus), range: NSMakeRange(0, bottomRowText.length))
        bottomRowText.append(NSAttributedString(string: " \(operatingStatusMessage) \u{ff5c} \u{2605} \(rating) \u{ff5c} \(pricing.rawValue)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customGrey, .font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 25)!]))
        return CardViewModel(placeImages: placeImages, headerText: headerText, topRowText: topRowText, bottomRowText: bottomRowText)
    }
    
    fileprivate func getOperatingStatusColor(status: String) -> UIColor {
        switch status {
        case "Open":
            return UIColor.customGreen
        default:
            return UIColor.customRed
        }
    }
}
