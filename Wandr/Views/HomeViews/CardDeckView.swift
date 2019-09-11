//
//  CardDeckView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/18/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//  Using the Gemini project at

import UIKit
import NVActivityIndicatorView

class CardDeckView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    let sendPlanTranslationThreshold: CGFloat = -100
    
    var cardsActivityIndicator: NVActivityIndicatorView!

    var cardViewModels: [CardViewModel]! {
        didSet {
            self.reusableDataSource = .make(for: cardViewModels)
            collectionView.dataSource = reusableDataSource
            collectionView.reloadData()
        }
    }
    
    
    //MARK:- Variables
    let cardCellId = "card"
    
    //MARK:- Elements
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = (contentMargin * 2)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = UIScrollView.DecelerationRate.fast
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        cv.layer.masksToBounds = false
        cv.layer.masksToBounds = false
        cv.layer.shadowOffset = CGSize(width: 0, height: 0)
        cv.layer.shadowOpacity = 0.3
        cv.layer.shadowRadius = 6.0
        cv.layer.shadowColor = UIColor.black.cgColor
        return cv
    }()
    
    var reusableDataSource: CollectionViewDataSource<CardViewModel>?
    
    //MARK:- View Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = false
        backgroundColor = .white
        setupCollectionView()
        setupCardsActivityIndicator()
        let planGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMakePlanGesture))
        collectionView.addGestureRecognizer(planGesture)
        planGesture.delegate = self
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(cardCell.self, forCellWithReuseIdentifier: "card")
        addSubview(collectionView)
        collectionView.fillSuperView() //calls function to fill entire superview in AutoLayoutExtension File
    }
    
    fileprivate func setupCardsActivityIndicator() {
        cardsActivityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30), type: .lineScale, color: .mainBlue, padding: nil)
        addSubview(cardsActivityIndicator)
        cardsActivityIndicator.centerInsideSuperView()
        cardsActivityIndicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cardsActivityIndicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- CollectionView Functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - (contentMargin * 2), height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: (contentMargin * 2) / 2, bottom: 0, right: (contentMargin * 2) / 2) //Padding to
    }
    
    @objc func handleMakePlanGesture(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed:
            let point = gesture.location(in: self.collectionView)
            
            if let indexPath = self.collectionView.indexPathForItem(at: point) {
                // get the cell at indexPath (the one you long pressed)
                let cell = self.collectionView.cellForItem(at: indexPath) as! cardCell
                
                handleMakePlanGestureChanged(cell, gesture)
            }
        case .ended:
            let point = gesture.location(in: self.collectionView)
            
            if let indexPath = self.collectionView.indexPathForItem(at: point) {
                // get the cell at indexPath (the one you long pressed)
                let cell = self.collectionView.cellForItem(at: indexPath) as! cardCell
                
                handleMakePlanGestureEnded(cell, gesture)
            }
        default: ()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CardDeckView {
    
    
    func handleMakePlanGestureChanged(_ cell: cardCell, _ gesture: UIPanGestureRecognizer) {
        let translationY = gesture.translation(in: nil).y
        if translationY < 0 {
            cell.transform = CGAffineTransform(translationX: 0, y: gesture.translation(in: nil).y)
        }
    }
    
    func handleMakePlanGestureEnded(_ cell: cardCell, _ gesture: UIPanGestureRecognizer) {
        let shouldDismiss = gesture.translation(in: nil).y < sendPlanTranslationThreshold
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            if shouldDismiss {
                cell.cardView.frame = CGRect(x: 0, y: -1000, width: cell.cardView.frame.width, height: cell.cardView.frame.height)
                self.showNewPlan(cell.cardView.cardViewModel)
            } else {
                cell.transform = .identity
            }
        }) { (_) in
            if shouldDismiss {
                cell.transform = .identity
                cell.cardView.frame = CGRect(x: 0, y: 0, width: cell.cardView.frame.width, height: cell.frame.height)
            }
        }
    }
    
    private func showNewPlan(_ cardViewModel: CardViewModel) {
        let vc = NewPlanController(planPlace: cardViewModel)
        let navController = UINavigationController(rootViewController: vc) // Creating a navigation controller with vc at the root of the navigation stack.
        UIApplication.shared.keyWindow?.rootViewController?.present(navController, animated: true, completion: nil)
    }
}

class cardCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    //MARK:- Subviews
    let cardView = CardView()
    
    //MARK:- Setup Cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cardView)
        cardView.fillSuperView()
        cardView.cardTop.moreInfoButton.addTarget(self, action: #selector(didTapMoreInfo), for: .touchUpInside)
        cardView.cardTop.saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        setupMenuLongPressGesture()
    }
    
    //MARK:- Logic
    @objc func didTapMoreInfo() {
        let cardActionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        cardActionsMenu.addAction(UIAlertAction(title: "Make Plan", style: .default, handler: { (_) in
//            self.showNewPlan()
        }))
        cardActionsMenu.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            print("Save")
        }))
        cardActionsMenu.addAction(UIAlertAction(title: "Navigate", style: .default, handler: { (_) in
            print("Navigate")
        }))
        cardActionsMenu.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { (_) in
            print("Report")
        }))
        cardActionsMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("Cancel")
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(cardActionsMenu, animated: true, completion: nil)
    }
    
    func setupMenuLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapMoreInfo))
        addGestureRecognizer(gesture)
    }
    
    @objc func saveItem() {
        if cardView.cardTop.saveButton.isSelected {
            cardView.cardTop.saveButton.isSelected = false
            cardView.cardTop.saveButton.alpha = 0.5
            cardView.cardTop.saveButton.tintColor = UIColor.black
        } else {
            cardView.cardTop.saveButton.isSelected = true
            cardView.cardTop.saveButton.alpha = 1.0
            cardView.cardTop.saveButton.tintColor = UIColor.mainBlue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
