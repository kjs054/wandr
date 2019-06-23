//
//  RegistrationController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/20/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import PhoneNumberKit

class RegistrationController: UIViewController {
    
    //MARK:- Variables
    var countryCode: String = "+1"
    
    let phoneNumberKit = PhoneNumberKit()
    
    //MARK:- Elements
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "wandrlogo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let selectCountryCode: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.setTitleColor(wandrBlue, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    
    let phoneNumField : PhoneNumberTextField = { //inputField found in LoginElements
        let input = PhoneNumberTextField()
        input.placeholder = "Phone Number"
        input.translatesAutoresizingMaskIntoConstraints = false
        input.layer.cornerRadius = 18
        input.keyboardType = UIKeyboardType.phonePad
        input.backgroundColor = .white
        input.textColor = wandrBlue
        input.font = UIFont(name: "Avenir-Heavy", size: 25)
        return input
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
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = wandrBlue
        setupContentView()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        phoneNumField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    fileprivate func setupContentView() {
        view.addSubview(contentView)
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.85).isActive = true
        contentView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        setupLogoImage()
        setupPhoneNumField()
        setupNextButton()
    }
    
    fileprivate func setupLogoImage() {
        contentView.addSubview(logoImage)
        logoImage.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
    
    fileprivate func setupPhoneNumField() {
        contentView.addSubview(phoneNumField)
        phoneNumField.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        phoneNumField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        phoneNumField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 35).isActive = true
        phoneNumField.leftView = selectCountryCode
        selectCountryCode.setTitle("🇺🇸 \(countryCode)", for: .normal)
        phoneNumField.leftViewMode = .always
    }
    
    fileprivate func setupNextButton() {
        contentView.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: phoneNumField.bottomAnchor, constant: 35).isActive = true
        nextButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(sendVerificationCode), for: .touchUpInside)
    }
    
    //MARK:- Logic
    @objc func sendVerificationCode() {
        let phoneNumber = countryCode + phoneNumField.text!
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) {
            (verificationID, error) in if error != nil {
                print("error: \(String(describing: error?.localizedDescription))")
            } else {
                let defaults = UserDefaults.standard
                defaults.set(verificationID, forKey: "authVID")
                let vc = VerifyCodeController()
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
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
