//
//  Event.swift
//  Wandr
//
//  Created by Kevin Shiflett on 7/18/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

struct event: ProducesCardViewModel {
    //Defining properties
    var name: String
    var city: String
    var distance: Double
    var cover_photo: String
    var date: String
    var start_time: String
    var end_time: String
    var ticket_pricing: String
    var attending_count: Int
    
    func toCardViewModel() -> CardViewModel {
        let headerText = NSMutableAttributedString(string: name, attributes: [.font: UIFont(name: "NexaBold", size: UIScreen.main.bounds.width / 17)!])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        headerText.append(NSAttributedString(string: "\n\(city) \u{2022} \(distance) mi", attributes: [.font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 20)!]))
        headerText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, headerText.length))
        let topRowText = NSAttributedString(string: "🗓 \(date) @ \(start_time) - \(end_time)", attributes: [.font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 22)!, .foregroundColor: #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)])
        let bottomRowText = NSAttributedString(string: "🎟 \(ticket_pricing) \u{ff5c} \(attending_count) Going", attributes: [.font: UIFont(name: "Avenir-Heavy", size: UIScreen.main.bounds.width / 25)!, .foregroundColor: #colorLiteral(red: 0.431372549, green: 0.431372549, blue: 0.431372549, alpha: 1)])
        return CardViewModel(placeImages: [cover_photo], headerText: headerText, topRowText: topRowText, bottomRowText: bottomRowText)
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
