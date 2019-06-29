//
//  ProfileController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/15/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    //MARK:- Variables
    let historyCardId = "historyCard"
    let savedCardId = "savedCard"
    
    //MARK:- Elements
    let segmentedControl: UISegmentedControl = {
        let items = ["Liked", "History"]
        let sc = UISegmentedControl(items: items)
        sc.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 15) ?? ""], for: .normal)
        sc.selectedSegmentIndex = 0
        sc.tintColor = wandrBlue
        return sc
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()

    //MARK:- Controller Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        setupCollectionView()
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        setupNavigationBar()
    }
    
    func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: view.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 15, bottom: 0, right: -15))
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(historyCardCell.self, forCellWithReuseIdentifier: historyCardId)
        collectionView.register(savedCardCell.self, forCellWithReuseIdentifier: savedCardId)
        view.addSubview(collectionView)
        collectionView.anchor(top: segmentedControl.bottomAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
    }
    
    func setupNavigationBar() {
        let backButton = UIButton()
        guard let name = currentUser["name"] as? String else {
            print("Name not found")
            return
        }
        navigationItem.title = name
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: wandrBlue, .font: UIFont(name: "NexaBold", size: 23)!]
        navigationController?.navigationBar.isTranslucent = false
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        backButton.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        let settingsButton = UIButton()
        settingsButton.setImage(#imageLiteral(resourceName: "settingsIcon"), for: .normal)
        settingsButton.imageView?.contentMode = .scaleAspectFit
        settingsButton.heightAnchor.constraint(equalToConstant: 29).isActive = true
        settingsButton.widthAnchor.constraint(equalTo: settingsButton.heightAnchor).isActive = true
        settingsButton.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingsButton)
    }
    //MARK:- Logic
    @objc func dismissViewController() {
        let transition = CATransition().fromRight()
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleLogOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            showRegistration()
        } catch let signOutError as NSError {
            print ("Error signing out : %@", signOutError)
            print ("error")
        }
    }
    
    @objc func showRegistration() {
        let vc = LoginController()
        let transition = CATransition().fromBottom()
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func segmentedControlValueChanged() {
        collectionView.reloadData()
    }
    
    //MARK:- CollectionView Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: historyCardId, for: indexPath) as! historyCardCell
            cell.card.cardViewModel = cardViewModels[indexPath.row]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: savedCardId, for: indexPath) as! savedCardCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.93, height: 375)
    }
}

class historyCardCell: UICollectionViewCell {
    let card = CardView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(card)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        card.fillSuperView()
        layer.cornerRadius = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class savedCardCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        layer.cornerRadius = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
