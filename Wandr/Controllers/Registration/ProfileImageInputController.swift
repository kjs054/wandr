//
//  RegistrationController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/20/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class ProfileImageInputController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK:- Elements
    let profilePicture: RoundedButton = {
        let pp = RoundedButton()
        pp.translatesAutoresizingMaskIntoConstraints = false
        pp.addTarget(self, action: #selector(handleProfilePictureChange), for: .touchUpInside)
        pp.setTitle("Add A Profile Picture", for: .normal)
        pp.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        pp.titleLabel?.adjustsFontSizeToFitWidth = true
        pp.setTitleColor(UIColor.mainBlue, for: .normal)
        pp.backgroundColor = .white
        return pp
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Next", for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        button.layer.cornerRadius = 18
        return button
    }()
    
    //MARK:- Controller Setup
    override func viewDidLoad() {
        view.backgroundColor = UIColor.mainBlue
        setupContentView()
        setupBirthdayInput()
        setupNextButton()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.view.backgroundColor = UIColor.mainBlue
    }
    
    fileprivate func setupContentView() {
        view.addSubview(contentView)
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.85).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 285).isActive = true
    }
    
    fileprivate func setupBirthdayInput() {
        contentView.addSubview(profilePicture)
        profilePicture.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profilePicture.heightAnchor.constraint(equalTo: profilePicture.widthAnchor).isActive = true
    }
    
    fileprivate func setupNextButton() {
        contentView.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 35).isActive = true
        nextButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
    }
    
    //MARK:- Logic
    @objc func handleRegistration() {
        let backend = BackEndFunctions()
        if let imageToUpload = profilePicture.imageView?.image {
            showActivityIndicator()
            let reference = "profileImages/\(String(describing: backend.getUserID))"
            backend.uploadImage(reference: reference, image: imageToUpload) {
                backend.downloadURL(reference: reference) { (imageURL) in
                    newUserData["profileImageURL"] = imageURL
                    backend.addNewUserToDatabase(userData: newUserData) {
                        self.showHomeViewController()
                    }
                }
            }
        } else {
            profilePicture.setTitle("Profile Picture Required", for: .normal)
        }
    }
    
    @objc func handleProfilePictureChange() {
        let alert = UIAlertController(title: "Select A Source", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            self.getImage(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.getImage(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true) {
            alert.view.superview?.subviews[1].isUserInteractionEnabled = true
            alert.view.superview?.subviews[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertBackgroundTapped)))
        }
    }
    
    @objc func alertBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getImage(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        dismiss(animated: true, completion: nil)
        profilePicture.setImage(editedImage, for: .normal)
    }
    
    fileprivate func showActivityIndicator() {
        let activityIndicator = activityIndicatorView(color: UIColor.mainBlue, labelText: "Setting Up Your Account")
        view.addSubview(activityIndicator)
        activityIndicator.fillSuperView()
    }
    
    fileprivate func showHomeViewController() {
        let vc = HomeController()
        let transition = CATransition().moveInTransition(direction: .fromTop)
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
