//
//  Place.swift
//  Wandr
//
//  Created by kevin on 6/6/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

struct place: ProducesCardViewModel {
    //Defining properties
    var title: String
    var category: String
    var city: String
    var distance: Double
    var minPrice: Int
    var maxPrice: Int
    var placeImages: [String]
    var savesCount: Int
    var operatingStatus: String
    var operatingStatusMessage: String
    var commentCount: Int
    
    func toCardViewModel() -> CardViewModel {
        let headerText = NSMutableAttributedString(string: title, attributes: [.font: UIFont(name: "NexaBold", size: UIScreen.main.bounds.width / 17)!])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        headerText.append(NSAttributedString(string: "\n\(city) \u{2022} \(distance) mi", attributes: [.font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 20)!]))
        headerText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, headerText.length))
        let bottomInfoText = NSMutableAttributedString(string: operatingStatus, attributes: [.font: UIFont(name: "Avenir-Black", size: UIScreen.main.bounds.width / 22)!])
        bottomInfoText.addAttribute(NSAttributedString.Key.foregroundColor, value: getOperatingStatusColor(status: operatingStatus), range: NSMakeRange(0, bottomInfoText.length))
        bottomInfoText.append(NSAttributedString(string: " \(operatingStatusMessage) \u{2022} \(commentCount) Comments", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1), .font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 26)!]))
        return CardViewModel(placeImages: placeImages, headerAttributedString: headerText, category: category, minPrice: minPrice, maxPrice: maxPrice, numOfSaves: savesCount, bottomAttributedString: bottomInfoText)
    }
    fileprivate func getOperatingStatusColor(status: String) -> UIColor {
        switch status {
        case "Open":
            return #colorLiteral(red: 0.07058823529, green: 0.8549019608, blue: 0.462745098, alpha: 1)
        default:
            return #colorLiteral(red: 0.9058823529, green: 0.2980392157, blue: 0.2352941176, alpha: 1)
        }
    }
}
