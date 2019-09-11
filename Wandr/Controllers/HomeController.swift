//
//  ViewController.swift
//  Wandr
//
//  Created by kevin on 5/30/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit

class HomeController: UIViewController {
    
    //MARK:- Elements    
    let localStorage = LocalStorage()
    
    let profileButton = circularImageView()
    
    let locationManager = CLLocationManager()
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "wandrwhite").withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let wavesBackgroundGraphic: UIImageView = {
        let waves = UIImageView(image: #imageLiteral(resourceName: "Waves"))
        return waves
    }()
    
    let filters: filtersView = {
        let view = filtersView()
        view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return view
    }()

    let cardDeckView = CardDeckView()
    
    //MARK:- Controller Setup Functions
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func fetchThingsToDo(lat: Double, lon: Double, radius: Double = 34000, limit: Int = 20, category: String? = nil) {
        //        self.cardDeckView.cardViewModels = [Place(id: "23841238jfsdk", name: "Test Place For Me", rating: 4.7, ratingCount: 122, location: Location(city: "sparks", country: "sdsaf", latitude: 32814283, longitude: 4138248, state: "MD", street: "1234 fdjasj", zip: "321"), placeImages: [""], operatingStatus: true, distance: 34, price_level: "$$", description: "Best place for burgers ever", types: "Restaurant", about: "Restuarant", likesCount: 314,  services: ["Pie": true], verified: true).toCardViewModel()]
        if cardDeckView.cardViewModels != nil { cardDeckView.cardViewModels.removeAll() }
        cardDeckView.cardsActivityIndicator.startAnimating()
        NetworkManager().getPlaces(lon: lon, lat: lat, radius: radius, limit: limit, category: category) { (places, error) in
            if let error = error {
                print(error)
            }
            if let places = places {
                DispatchQueue.main.async {
                    let viewModels = places.map({return $0.toCardViewModel()})
                    self.cardDeckView.cardViewModels = viewModels
                    self.cardDeckView.cardsActivityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func fetchCategories(parent: String = "none") {
        NetworkManager().getCategories { (categories, error) in
            if let error = error {
                print(error)
            }
            if let categories = categories {
                DispatchQueue.main.async {
                    let childrenCategories = categories.filter({$0.parent == parent})
                    if childrenCategories.isEmpty == false {
                        self.filters.categoryFilters.parentCategory = categories.first(where: {$0.alias == parent})
                        self.filters.categoryFilters.categories = categories.filter({$0.parent == parent})
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupWavesBackground()
        fetchThingsToDo(lat: locationManager.location!.coordinate.latitude, lon: locationManager.location!.coordinate.longitude)
        fetchCategories()
        setupNavigationBar()
        view.backgroundColor = UIColor.white
        self.filters.categoryFilters.selectionDelegate = self
        setupLayout()
        BackEndFunctions().fetchUserData(uid: BackEndFunctions().getUserID()) { (userData) in
            if let userData = userData {
                self.localStorage.saveCurrentUserData(userData: userData)
                self.setupProfilePictureNavigationBar()
            } else {
                self.showLogin()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupProfilePicture()
        navigationController!.navigationBar.layer.zPosition = -1;
    }
    
    func hasBottomSafeArea() -> Bool {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
    }
    
    fileprivate func setupLayout() {
        let mainView = UIStackView(arrangedSubviews: [filters, cardDeckView])
        mainView.setCustomSpacing(20, after: filters)
        mainView.axis = .vertical
        self.view.addSubview(mainView)
        let bottomPadding: CGFloat = hasBottomSafeArea() ? 16 : 0
        mainView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: bottomPadding + 60, right: 0))
        mainView.isLayoutMarginsRelativeArrangement = true
        mainView.bringSubviewToFront(cardDeckView)
    }
    
    fileprivate func setupWavesBackground() {
        view.addSubview(wavesBackgroundGraphic)
        wavesBackgroundGraphic.anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0))
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
        navigationController?.view.backgroundColor = .white
        navigationItem.titleView?.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        let myPlansButton = UIButton()
        myPlansButton.addTarget(self, action: #selector(showPlans), for: .touchUpInside)
        myPlansButton.setImage(#imageLiteral(resourceName: "messageIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: myPlansButton)
        setupActivityIndicator()
    }
    
    //MARK:- Navigation Functions
    @objc func showProfile() {
        let vc = ProfileController()
        let transition = CATransition().pushTransition(direction: .fromLeft)
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func showPlans() {
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
        if let imageURL = localStorage.currentUserData()?.profileImageURL { //Unwraps url stored as type Any to String
            profileButton.setCachedImage(urlstring: imageURL, size: CGSize(width: 45, height: 45)) {
                self.setupProfilePicture()
            }
        }
    }
}

extension HomeController: categorySelectionDelegate {
    
    func showCategoryChildren(_ categoryAlias: String) {
        fetchCategories(parent: categoryAlias)
    }
    
    func updateThingsToDo(_ categoryAlias: String) {
        if categoryAlias.isEmpty {
            fetchThingsToDo(lat: locationManager.location!.coordinate.latitude, lon: locationManager.location!.coordinate.longitude)
        } else {
            fetchThingsToDo(lat: locationManager.location!.coordinate.latitude, lon: locationManager.location!.coordinate.longitude, category: categoryAlias)
        }
    }
    
    func updateNavTitle(_ categoryName: String) {
        if categoryName.isEmpty {
            navigationItem.titleView = titleImageView
        } else {
            navigationItem.titleView = nil
            navigationItem.title = categoryName
            let attrs = [
                NSAttributedString.Key.foregroundColor: UIColor.mainBlue,
                NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 20)!
                ] as [NSAttributedString.Key : Any]
            navigationController?.navigationBar.titleTextAttributes = attrs
        }
    }
}

extension HomeController: CLLocationManagerDelegate {
    func setupLocationManager() {
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startMonitoringSignificantLocationChanges()
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
