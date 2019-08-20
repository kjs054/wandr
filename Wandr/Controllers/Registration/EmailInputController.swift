//
//  RegistrationController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/20/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailInputController: UIViewController {
    
    //MARK:- Elements
    let emailField: LoginAndRegisterTextField = {
        let field = LoginAndRegisterTextField()
        field.autocorrectionType = .no
        field.adjustsFontSizeToFitWidth = true
        field.textAlignment = .center
        field.placeholder = "Email Address"
        return field
    }()
    
    let infoLabel: LoginAndRegisterInfoLabel = {
        let label = LoginAndRegisterInfoLabel()
        label.text = "In Case You Change Phone Numbers"
        return label
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
        setupInfoLabel()
        setupEmailField()
        setupNextButton()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        emailField.becomeFirstResponder()
    }
    
    fileprivate func setupInfoLabel() {
        contentView.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    fileprivate func setupContentView() {
        view.addSubview(contentView)
        contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.85).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 213).isActive = true
    }
    
    fileprivate func setupEmailField() {
        contentView.addSubview(emailField)
        emailField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 35).isActive = true
        emailField.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setupNextButton() {
        contentView.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 35).isActive = true
        nextButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(addEmailToData), for: .touchUpInside)
    }
    
    //MARK:- Logic
    @objc func addEmailToData() {
        if emailField.text != nil {
            newUserData["email"] = emailField.text!
            showNextController()
        } else {
            infoLabel.text = "A Valid Email is Required"
        }
    }
    
    func showNextController() {
        let vc = NameInputController()
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
