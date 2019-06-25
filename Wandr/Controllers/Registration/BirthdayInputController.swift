//
//  RegistrationController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/20/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class BirthdayInputController: UIViewController {
    
    //MARK:- Elements
    let birthdayField: LoginAndRegisterTextField = {
        let field = LoginAndRegisterTextField()
        field.autocorrectionType = .no
        field.adjustsFontSizeToFitWidth = true
        field.textAlignment = .center
        field.placeholder = "Birthday"
        let birthdayPicker = UIDatePicker()
        birthdayPicker.datePickerMode = .date
        birthdayPicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        field.inputView = birthdayPicker
        return field
    }()
    
    let infoLabel: LoginAndRegisterInfoLabel = {
        let label = LoginAndRegisterInfoLabel()
        label.text = "Your Age Helps Get More Accurate Results"
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
        setupBirthdayInput()
        setupNextButton()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.navigationController?.view.backgroundColor = wandrBlue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        birthdayField.becomeFirstResponder()
    }
    
    fileprivate func setupInfoLabel() {
        contentView.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    fileprivate func setupContentView() {
        view.addSubview(contentView)
        contentView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.85).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 213).isActive = true
    }
    
    fileprivate func setupBirthdayInput() {
        contentView.addSubview(birthdayField)
        birthdayField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 35).isActive = true
        birthdayField.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        birthdayField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setupNextButton() {
        contentView.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: birthdayField.bottomAnchor, constant: 35).isActive = true
        nextButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(showNextController), for: .touchUpInside)
    }
    
    //MARK:- Logic
    @objc func showNextController() {
        let vc = ProfileImageInputController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdayField.text = dateFormatter.string(from: datePicker.date)
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
