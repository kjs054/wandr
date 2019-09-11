//
//  CardView.swift
//  Wandr
//
//  Created by kevin on 6/4/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

//Configurations
let cardCornerRadius: CGFloat = 20

let contentMargin: CGFloat = UIScreen.main.bounds.width * 0.045

class CardView: UIStackView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            cardTop.imageView.image = UIImage()
            let imageName = cardViewModel.placeImages.first ?? ""
            cardTop.imageView.downloaded(from: imageName, contentMode: .scaleAspectFill)
            cardBottom.titleLabel.text = cardViewModel.headerContent["title"]
            cardBottom.distanceLabel.text = cardViewModel.headerContent["distance"]
            cardBottom.setupDetailsStacks(content: cardViewModel.detailsContent)
            cardTop.saveButton.tintColor = .black
            cardTop.saveButton.alpha = 0.5
//            cardBottom.topRowLabel.attributedText = cardViewModel.topRowText
            cardTop.imageBars.arrangedSubviews.forEach { (bar) in bar.removeFromSuperview() }
            (0..<cardViewModel.placeImages.count).forEach { (_) in setupBarView() }
            cardTop.imageBars.arrangedSubviews.first?.backgroundColor = UIColor.white
        }
    }
    
    let cardTop = topOfCard()
    let cardBottom = bottomOfCard()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addArrangedSubview(cardTop)
        cardBottom.heightAnchor.constraint(equalToConstant: 250).isActive = true
        setupCardBottom()
        axis = .vertical
        cardTop.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
    }
    
    func setupCardBottom() {
        addArrangedSubview(cardBottom)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handleImageTap(gesture: UITapGestureRecognizer) {
        gesture.numberOfTapsRequired = 1
        let tapLocation = gesture.location(in: nil)
        let shouldAdvance = tapLocation.x > cardTop.frame.width / 2 ? true : false
        setupImageIndexObserver()
        if shouldAdvance {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [unowned self] (idx, image) in
            self.cardTop.imageView.image = image
            self.cardTop.imageBars.arrangedSubviews.forEach({ (bar) in
                bar.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
            })
            self.cardTop.imageBars.arrangedSubviews[idx].backgroundColor = UIColor(white: 1, alpha: 1)
        }
    }
    
    fileprivate func setupBarView() {
        let barView = UIView()
        barView.layer.cornerRadius = 1.5
        barView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        cardTop.imageBars.addArrangedSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func getPricingText(minPrice: Int, maxPrice: Int) -> String {
        let free = (maxPrice == 0) ? "Free" : "$\(minPrice)-\(maxPrice)"
        return free
    }
}
