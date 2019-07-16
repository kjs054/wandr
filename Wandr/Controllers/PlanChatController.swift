//
//  PlanChatController.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/15/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class PlanChatController: UIViewController {
    
    //MARK:- Elements
    let mainView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()

    let membersCollection = selectedUsersCollectionView()
    
    let chatView = UIView()
    
    let createMessage = CreateMessageView()
    
    //MARK:- Controller Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        setupNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(keyboardWillHide))
        view.addGestureRecognizer(gesture)
    }
    
    func setupNavigationBar() {
        let backButton = UIButton()
        navigationItem.title = "Chat Name"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: wandrBlue, .font: UIFont(name: "NexaBold", size: 23)!]
        navigationController?.navigationBar.isTranslucent = false
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        backButton.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    fileprivate func setupMainView() {
        view.addSubview(mainView)
        let subviews = [membersCollection, chatView, createMessage]
        mainView.fillSuperView()
        subviews.forEach { (sv) in
            mainView.addArrangedSubview(sv)
            membersCollection.heightAnchor.constraint(equalToConstant: 60).isActive = true
            createMessage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
    }
    
    let bottomSafeArea = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    @objc func keyboardWillHide(notification: NSNotification) {
        view.endEditing(true)
        createMessage.frame.origin.y = (view.frame.height - createMessage.frame.height - bottomSafeArea)
    }
    
    //MARK:- Logic
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            createMessage.frame.origin.y -= keyboardHeight - bottomSafeArea
        }
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        let transition = CATransition().fromLeft()
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }
}
