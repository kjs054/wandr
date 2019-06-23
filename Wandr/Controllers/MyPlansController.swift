//
//  Contacts.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/11/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class MyPlansController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK:- Variables
    let planPreviewId = "planPreviewId"
    
    let informationCellId = "informationCellId"
    
    //MARK:- Elements
    let tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.allowsSelection = true
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    //MARK:- Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setupTableView()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let backButton = UIButton()
        navigationItem.title = "My Plans"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: wandrBlue, .font: UIFont(name: "NexaBold", size: 23)!]
        navigationController?.navigationBar.isTranslucent = false
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        backButton.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    //MARK:- Plans Table Functions
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(planPreviewCell.self, forCellReuseIdentifier: planPreviewId)
        tableView.register(InformationCell.self, forCellReuseIdentifier: informationCellId)
        tableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 5, left: 15, bottom: 0, right: 0))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            showPlanChatController()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: informationCellId, for: indexPath) as! InformationCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: planPreviewId, for: indexPath) as! planPreviewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 400
        }
        return 100
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        let transition = CATransition().fromLeft()
        navigationController!.view.layer.add(transition, forKey: nil)
        navigationController?.popViewController(animated: false)
    }
    
    func showPlanChatController() {
        let vc = PlanChatController()
        let transition = CATransition().fromRight()
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
    }
}


class planPreviewCell: UITableViewCell {
    
    //MARK:- Subviews
    let contactCellView = ContactView()
    
    //MARK:- Setup Cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(contactCellView)
        contactCellView.setupTimeStamp()
        contactCellView.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InformationCell: UITableViewCell {
    
    //MARK:- Subviews
    let couchImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "couch"))
        return imageView
    }()
    
    let informationTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "NexaBold", size: 20)
        label.textColor = wandrBlue
        label.text = "Lets Make Some Better Plans"
        return label
    }()
    
    let informationSubTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.textColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Another night on the couch? \n Send a place to a friend(s) and \n make some plans"
        return label
    }()
    
    //MARK:- Setup Cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCouchImage()
        setupInformationTitle()
        setupInformationSubTitle()
    }
    
    func setupCouchImage() {
        addSubview(couchImage)
        couchImage.anchor(top: topAnchor, bottom: nil, leading: nil, trailing: nil, padding: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0))
        couchImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        couchImage.heightAnchor.constraint(equalTo: couchImage.widthAnchor).isActive = true
        couchImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setupInformationTitle() {
        addSubview(informationTitle)
        informationTitle.anchor(top: couchImage.bottomAnchor, bottom: nil, leading: nil, trailing: nil, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        informationTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setupInformationSubTitle() {
        addSubview(informationSubTitle)
        informationSubTitle.anchor(top: informationTitle.bottomAnchor, bottom: nil, leading: nil, trailing: nil, padding: UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0))
        informationSubTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
