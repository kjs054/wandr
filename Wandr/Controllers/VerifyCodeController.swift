//
//  RegistrationController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/20/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class VerifyCodeController: UIViewController, UITextFieldDelegate {
    
    //MARK:- Elements
    let codeField: UITextField = {
        let field = UITextField()
        field.keyboardType = .numberPad
        field.backgroundColor = .white
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 18
        field.font = UIFont(name: "Avenir-Heavy", size: 30)
        field.textColor = wandrBlue
        field.textAlignment = .center
        field.autocorrectionType = .no
        field.placeholder = "Code"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Ding! We Sent You A Code"
        label.font = UIFont(name: "NexaBold", size: 25)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
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
        setupCodeField()
        setupNextButton()
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        codeField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        codeField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        codeField.becomeFirstResponder()
    }

    fileprivate func setupInfoLabel() {
        contentView.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    fileprivate func setupContentView() {
        view.addSubview(contentView)
        contentView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.85).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 213).isActive = true
    }
    
    fileprivate func setupCodeField() {
        contentView.addSubview(codeField)
        codeField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 35).isActive = true
        codeField.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        codeField.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    fileprivate func setupNextButton() {
        contentView.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: codeField.bottomAnchor, constant: 35).isActive = true
        nextButton.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(attemptSignIn), for: .touchUpInside)
    }
    
    //MARK:- Logic
    @objc func attemptSignIn() {
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVID")!, verificationCode: codeField.text!)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print("error: \(error!.localizedDescription)")
            } else {
                let vc = HomeController()
                let transition = CATransition().fromBottom()
                self.navigationController!.view.layer.add(transition, forKey: kCATransition)
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 6
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
