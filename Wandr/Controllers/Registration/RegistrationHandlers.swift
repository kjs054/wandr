//
//  RegistrationHandlers.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/25/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


extension ProfileImageInputController {
    
    func handleRegister() {
        nextButton.isEnabled = false
        let db = Firestore.firestore()
        let uid = newUserData["uid"]!
        db.collection("users").document(uid).setData(newUserData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                self.showNextController()
            }
        }
    }
    
    fileprivate func showNextController() {
        let vc = HomeController()
        let transition = CATransition().fromBottom()
        navigationController!.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func uploadImageToStorage(image: UIImage) {
        showActivityIndicator()
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profileImages/\(newUserData["uid"]!)")
        if let uploadData = (image).pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url?.absoluteString else {
                        print(error!)
                        return
                    }
                    newUserData["profileImageURL"] = downloadURL
                    print(downloadURL)
                    self.handleRegister()
                })
            }
        }
    }
    
    func showActivityIndicator() {
        let activityIndication = UIActivityIndicatorView(style: .whiteLarge)
        view.addSubview(activityIndication)
        activityIndication.fillSuperView()
        activityIndication.backgroundColor = wandrBlue
        activityIndication.startAnimating()
        activityIndication.layer.opacity = 1
    }
}
