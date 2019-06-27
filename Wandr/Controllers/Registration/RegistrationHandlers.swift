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
    //MARK:- Logic
    func handleRegister() {
        nextButton.isEnabled = false
        let db = Firestore.firestore()
        guard let uid = newUserData["uid"] else {
            print("Error: No valid UID!")
            return
        }
        db.collection("users").document(uid).setData(newUserData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document Written Successfully")
                self.showNextController()
            }
        }
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

    fileprivate func showNextController() {
        let vc = HomeController()
        let transition = CATransition().fromBottom()
        navigationController!.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func showActivityIndicator() {
        let activityIndicator = ActivityIndicatorView()
        view.addSubview(activityIndicator)
        activityIndicator.fillSuperView()
    }
}
