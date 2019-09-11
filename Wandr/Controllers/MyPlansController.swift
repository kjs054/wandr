//
//  Contacts.swift
//  Wandr
//
//  Created by Kevin Shiflett on 6/11/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class MyPlansController: UIViewController, UITableViewDelegate {
    
    
    //MARK:- Variables
    let backendFunctions = BackEndFunctions()
    
    var planChats = [PlanChat]()
    
    let planPreviewId = "planPreviewId"
    
    let informationCellId = "informationCellId"
    
    //MARK:- Elements
    private var dataSource:SectionedTableViewDataSource?
    
    let refreshControl = UIRefreshControl()
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.allowsSelection = true
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    //MARK:- Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getTableData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(getTableData), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func getTableData() {
        backendFunctions.fetchUserChats(uid: backendFunctions.getUserID()) { (chats)  in
            if let chats = chats {  self.planChats = chats  }
            self.setupTableView()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    func setupNavigationBar() {
        let backButton = UIButton()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "My Plans"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainBlue, .font: UIFont(name: "Avenir-Heavy", size: 19)!]
        navigationController?.navigationBar.isTranslucent = false
        backButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        backButton.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
        backButton.imageView?.contentMode = .scaleAspectFit
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.navigationBar.addShadow()
        navigationController?.navigationBar.layer.zPosition = 2
    }
    
    //MARK:- Plans Table Functions
    func setupTableView() {
        dataSource = SectionedTableViewDataSource(dataSources: [TableViewDataSource.make(for: planChats, reuseIdentifier: planPreviewId), TableViewDataSource.make(for: [InformationView(image: #imageLiteral(resourceName: "couch"), title: "Lets Make Some Better Plans", subtitle: "Another night on the couch? \n Send a place to a friend(s) and \n make some plans.")], reuseIdentifier: "betterPlans")])
        tableView.delegate = self
        tableView.dataSource = dataSource
        view.addSubview(tableView)
        tableView.register(planPreviewCell.self, forCellReuseIdentifier: planPreviewId)
        tableView.register(informationCell.self, forCellReuseIdentifier: "betterPlans")
        tableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        setupRefreshControl()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            showPlanChatController(planChat: planChats[indexPath.item])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if planChats.isEmpty {
                tableView.isScrollEnabled = false
                return tableView.frame.height
            } else {
                tableView.isScrollEnabled = true
                return 400
            }
        }
        return 90
    }
    
    //MARK:- Navigation Functions
    @objc func dismissViewController() {
        let transition = CATransition().pushTransition(direction: CATransitionSubtype.fromLeft)
        navigationController!.view.layer.add(transition, forKey: nil)
        navigationController?.popToRootViewController(animated: false)
    }
    
    func showPlanChatController(planChat: PlanChat) {
        let vc = PlanChatController(chatID: planChat.chatID)
        let transition = CATransition().pushTransition(direction: .fromRight)
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}


class planPreviewCell: UITableViewCell {
    
    var plan: PlanChat! {
        didSet {
            if plan.members.count > 1 { plan.members.removeAll(where: {$0.name == LocalStorage().currentUserData()?.name}) }
            if plan.members.count > 4 { plan.members = Array(plan.members[0..<4]) }
            setTimestamp()
            self.previewView.subTitle.text = plan.mostRecentMessage.getDisplayText()
            let planName = plan.name.isEmpty ? plan.members.map({$0.name}).joined(separator: ", ") : plan.name
            previewView.title.text = planName
            previewView.members = plan.members
        }
    }
    
    @objc func setTimestamp() {
        Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(setTimestamp), userInfo: nil, repeats: true)
        self.previewView.timeStamp.text = plan.mostRecentMessage.timestamp.offset()
    }
    
    //MARK:- Subviews
    let previewView = planChatPreview()
    
    //MARK:- Setup Cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(previewView)
        previewView.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class informationCell: UITableViewCell {
    
    //MARK:- Subviews
    var infoView: InformationView! {
        didSet {
            setupInformationView()
        }
    }
    
    //MARK:- Setup Cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    func setupInformationView() {
        addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        infoView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
