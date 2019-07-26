//
//  ViewController.swift
//  Wandr
//
//  Created by kevin on 5/30/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeController: UIViewController {

    //MARK:- Variables
    
    //MARK:- Elements    
    let localStorage = LocalStorage()
    
    let profileButton = circularImageView()
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.image = #imageLiteral(resourceName: "wandrwhite")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let filters: filtersView = {
        let view = filtersView()
        view.heightAnchor.constraint(equalToConstant: 90).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return view
    }()
    
    let cardDeckView: CardDeckView = {
        let cdview = CardDeckView()
        //Setup Card Shadow
        cdview.layer.shadowOffset = CGSize(width: 0, height: 4)
        cdview.layer.shadowOpacity = 0.1
        cdview.layer.shadowColor = UIColor.black.cgColor
        return cdview
    }()
    
    //MARK:- Controller Setup Functions
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.filters.categoryFilters.selectionDelegate = self
        self.navigationController?.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupNavigationBar()
        setupLayout()
        fetchCurrentUserData(uid: getUID()) { (userData) in
            if let userData = userData {
                self.localStorage.saveCurrentUserData(userData: userData)
                self.setupProfilePictureNavigationBar()
            } else {
                self.showLogin()
            }
        }
    }
    
    func hasBottomSafeArea() -> Bool {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
    }
    
    fileprivate func setupLayout() {
        let mainView = UIStackView(arrangedSubviews: [filters, cardDeckView])
        mainView.setCustomSpacing(15, after: filters)
        mainView.axis = .vertical
        self.view.addSubview(mainView)
        let bottomPadding: CGFloat = hasBottomSafeArea() ? 16 : 0
        mainView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: -(bottomPadding + 20), right: 0))
        mainView.isLayoutMarginsRelativeArrangement = true
        mainView.bringSubviewToFront(cardDeckView)
    }
    
    fileprivate func setupProfilePicture() {
        profileButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        profileButton.clipsToBounds = true
        let profileButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        profileButton.addGestureRecognizer(profileButtonTapGesture)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
    
    fileprivate func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.widthAnchor.constraint(equalToConstant: 45).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 45).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
    }
    
    func setupNavigationBar() {
        navigationItem.titleView = titleImageView
        navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        let myPlansButton = UIButton()
        myPlansButton.addTarget(self, action: #selector(showMessages), for: .touchUpInside)
        myPlansButton.setImage(#imageLiteral(resourceName: "messageIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: myPlansButton)
        setupActivityIndicator()
        self.navigationController!.navigationBar.layer.zPosition = -1;
    }
    
    //MARK:- Navigation Functions
    @objc func showProfile() {
        let vc = ProfileController()
        let transition = CATransition().pushTransition(direction: .fromLeft)
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func showMessages() {
        let vc = MyPlansController()
        let transition = CATransition().pushTransition(direction: .fromRight)
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func showLogin() {
        let vc = LoginController()
        let transition = CATransition().moveInTransition(direction: .fromBottom)
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func showRegistration() {
        let vc = LoginController()
        let transition = CATransition().moveInTransition(direction: .fromBottom)
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func setupProfilePictureNavigationBar() {
        guard let imageURL = localStorage.currentUserData()?["profileImageURL"] as? String else { //Unwraps url stored as type Any to String
            print("Could not get image url for some fucking reason")
            return
        }
        self.profileButton.loadImageWithCacheFromURLString(urlstring: imageURL) {
            self.activityIndicator.stopAnimating()
            self.setupProfilePicture()
        } //Download, cache, and display
    }
}

extension HomeController: categorySelectionDelegate {
    func updateNavTitle(_ categoryName: String) {
        if categoryName.isEmpty {
            navigationItem.titleView = titleImageView
        } else {
            navigationItem.titleView = nil
            navigationItem.title = categoryName
            let attrs = [
                NSAttributedString.Key.foregroundColor: wandrBlue,
                NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 20)!
                ] as [NSAttributedString.Key : Any]
            navigationController?.navigationBar.titleTextAttributes = attrs
        }
    }
}
