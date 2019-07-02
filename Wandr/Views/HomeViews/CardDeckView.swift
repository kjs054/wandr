//
//  CardDeckView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/18/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//  Using the Gemini project at

import UIKit
import Gemini

class CardDeckView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK:- Variables
    let cardCellId = "card"
    
    //MARK:- Elements
    let collectionView: GeminiCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        let cv = GeminiCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    //MARK:- View Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cardCell.self, forCellWithReuseIdentifier: cardCellId)
        collectionView.gemini.rollRotationAnimation().scale(0.6).rollEffect(.rollDown).degree(60) //Sets up animation for swiping through cards using Gemini
        addSubview(collectionView)
        collectionView.fillSuperView() //calls function to fill entire superview in AutoLayoutExtension File
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardCellId, for: indexPath) as! cardCell
        cell.cardView.cardViewModel = cardViewModels[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.collectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 20, height: frame.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) //Padding to
    }

}

class cardCell: GeminiCell {
    
    let cardView = CardView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cardView)
        cardView.fillSuperView()
        cardView.cardBottom.moreInfoButton.addTarget(self, action: #selector(didTapMoreInfo), for: .touchUpInside)
    }
    
    @objc func didTapMoreInfo() {
        let cardActionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        cardActionsMenu.addAction(UIAlertAction(title: "Make Plan", style: .default, handler: { (_) in
            print("Make Plan")
        }))
        cardActionsMenu.addAction(UIAlertAction(title: "Like", style: .default, handler: { (_) in
            print("Like")
        }))
        cardActionsMenu.addAction(UIAlertAction(title: "Navigate", style: .default, handler: { (_) in
            print("Navigate")
        }))
        cardActionsMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("Cancel")
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(cardActionsMenu, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
