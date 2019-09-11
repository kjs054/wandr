//
//  Concert.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/11/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

//struct Concert: ProducesCardViewModel {
//    //Defining properties
//    var name: String
//    var city: String
//    var distance: Double
//    var cover_photo: String
//    var date: String
//    var start_time: String
//    var venue: String
//
//    func toCardViewModel() -> CardViewModel {
//        let headerText = NSMutableAttributedString(string: name, attributes: [.font: UIFont(name: "NexaBold", size: UIScreen.main.bounds.width / 17)!])
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 10
//        headerText.append(NSAttributedString(string: "\n\(city) \u{2022} \(distance) mi", attributes: [.font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 20)!]))
//        headerText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, headerText.length))
//        let topRowText = NSAttributedString(string: "🗓 \(date) @ \(start_time)", attributes: [.font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 22)!, .foregroundColor: UIColor.customGrey])
//        let bottomRowText = NSAttributedString(string: "📍 \(venue)", attributes: [.font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 25)!, .foregroundColor: UIColor.customGrey])
//        return CardViewModel(placeImages: [cover_photo], titleRowContent: headerText, generalInfoRowContent: topRowText, detailsRowContent: bottomRowText)
//    }
//}
