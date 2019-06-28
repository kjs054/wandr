//
//  RegistrationController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/20/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class NameInputController: UIViewController {
    
    //MARK:- Elements
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let infoLabel: LoginAndRegisterInfoLabel = {
        let label = LoginAndRegisterInfoLabel()
        label.text = "Oh Na Na, What's Your..."
        return label
    }()
    
    let firstName: LoginAndRegisterTextField = {
        let field = LoginAndRegisterTextField()
        field.autocorrectionType = .no
        field.adjustsFontSizeToFitWidth = true
        field.textAlignment = .center
        field.placeholder = "First Name"
        return field
    }()
    
    let lastName: LoginAndRegisterTextField = {
        let field = LoginAndRegisterTextField()
        field.autocorrectionType = .no
        field.adjustsFontSizeToFitWidth = true
        field.textAlignment = .center
        field.placeholder = "Last Name"
        return field
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Next", for: .normal)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(wandrBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        button.layer.cornerRadius = 18
        return button
    }()
    
    //MARK:- Controller Setup
    override func viewDidLoad() {
        view.backgroundColor = wandrBlue
        setupContentView()
        setupInfoLabel()
        setupFirstNameField()
        setupLastNameField()
        setupNextButton()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.navigationController?.view.backgroundColor = wandrBlue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        firstName.becomeFirstResponder()
    }
    
    fileprivate func setupContentView() {
        view.addSubview(contentView)
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.85).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    fileprivate func setupInfoLabel() {
        contentView.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    fileprivate func setupFirstNameField() {
        contentView.addSubview(firstName)
        firstName.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 35).isActive = true
        firstName.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        firstName.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setupLastNameField() {
        contentView.addSubview(lastName)
        lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 20).isActive = true
        lastName.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        lastName.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setupNextButton() {
        contentView.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: 35).isActive = true
        nextButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.addTarget(self, action: #selector(addNameToData), for: .touchUpInside)
    }
    
    //MARK:- Logic
    @objc func addNameToData() {
        if firstName.text != nil, lastName.text != nil {
            newUserData["name"] = "\(firstName.text!) \(lastName.text!)"
            showNextController()
        } else {
            infoLabel.text = "Please Enter Your Name"
        }
    }
    
    @objc func showNextController() {
        let vc = BirthdayInputController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    var minHeight = CGFloat()
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                if self.view.frame.height == self.minHeight {
                    return
                } else {
                    self.minHeight = self.view.frame.height - keyboardSize.height
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.minHeight)
                    self.view.layoutIfNeeded()
                }
            }) { (_) in
                ()
            }
        }
    }
}
