//
//  HomeControllerDataHandlers.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/27/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth

var currentUser = [String : Any]() //dictionary of the logged in users data

extension HomeController {
    
    func fetchUserData() { //gets the users data from firestore and stores it in currentUser dictionary
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else {
            fatalError("No user ID found! WTF is going on!")
        }
        let docRef = db.collection("users").document(uid) //Retrieves document named with users id
        docRef.getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                if snapshot.exists {
                    let imageURL = snapshot.get("profileImageURL") as! String
                    currentUser["profileImageURL"] = imageURL //Add URL of users profile image to current user dict.
                    //Perform element setup after fetching complete
                    self.setupProfilePictureNavigationBar()
                } else {
                    self.showRegistration()
                }
            }
        }
    }
    
    func showRegistration() {
        let vc = LoginController()
        let transition = CATransition().fromBottom()
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func setupProfilePictureNavigationBar() {
        guard let imageURL = currentUser["profileImageURL"] as? String else { //Unwraps url stored as type Any to String
            print("Could not get image url for some fucking reason")
            return
        }
        self.profileButton.loadImageWithCacheFromURLString(urlstring: imageURL) //Download, cache, and display
    }
}
