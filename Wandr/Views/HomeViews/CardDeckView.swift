//
//  CardDeckView.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/18/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//  Using the Gemini project at

import UIKit
import Gemini

class CardDeckView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
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
        cv.layer.masksToBounds = false
        return cv
    }()
    
    var reusableDataSource: CollectionViewDataSource<CardViewModel>?
    
    //MARK:- View Setup
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = false
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        self.reusableDataSource = .make(for: cardViewModels)
        collectionView.dataSource = reusableDataSource
        collectionView.register(cardCell.self, forCellWithReuseIdentifier: "card")
        collectionView.gemini.scaleAnimation().scale(0.6)
        addSubview(collectionView)
        collectionView.fillSuperView() //calls function to fill entire superview in AutoLayoutExtension File
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- CollectionView Functions
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.collectionView.animateVisibleCells()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 20, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) //Padding to
    }

}

class cardCell: GeminiCell, UIGestureRecognizerDelegate {
    
    //MARK:- Subviews
    let cardView = CardView()
    let sendPlanTranslationThreshold: CGFloat = -100
    
    //MARK:- Setup Cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cardView)
        cardView.fillSuperView()
        cardView.cardBottom.moreInfoButton.addTarget(self, action: #selector(didTapMoreInfo), for: .touchUpInside)
        setupMenuLongPressGesture()
        setupPlanGesture()
    }
    
    func setupPlanGesture() {
        let planGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMakePlanGesture))
        addGestureRecognizer(planGesture)
        planGesture.delegate = self
        handleMakePlanGesture(planGesture)
    }
    
    //MARK:- Logic
    @objc func didTapMoreInfo() {
        let cardActionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        cardActionsMenu.addAction(UIAlertAction(title: "Make Plan", style: .default, handler: { (_) in
            self.showNewPlan()
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
    
    func handlePlanGestureEnded(_ gesture: UIPanGestureRecognizer) {
        let shouldDismiss = gesture.translation(in: nil).y < sendPlanTranslationThreshold
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            if shouldDismiss {
                self.cardView.frame = CGRect(x: 0, y: -1000, width: self.cardView.frame.width, height: self.cardView.frame.height)
                self.showNewPlan()
            } else {
                self.cardView.transform = .identity
            }
        }) { (_) in
            if shouldDismiss {
                self.cardView.transform = .identity
                self.cardView.frame = CGRect(x: 0, y: 0, width: self.cardView.frame.width, height: self.cardView.frame.height)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (cardView.frame.origin.y < 0) {
            return false
        } else {
            return true
        }
    }
    
    @objc fileprivate func handleMakePlanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handlePlanGestureChanged(gesture)
        case .ended:
            handlePlanGestureEnded(gesture)
        default:
            ()
        }
    }
    
    func handlePlanGestureChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil).y
        if translation < 0 {
            self.cardView.transform = CGAffineTransform(translationX: 0, y: gesture.translation(in: nil).y)
        }
    }
    
    func setupMenuLongPressGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapMoreInfo))
        addGestureRecognizer(gesture)
    }
    
    private func showNewPlan() {
        let vc = NewPlanController(planPlace: cardView.cardViewModel)
        let navController = UINavigationController(rootViewController: vc) // Creating a navigation controller with vc at the root of the navigation stack.
        UIApplication.shared.keyWindow?.rootViewController?.present(navController, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
