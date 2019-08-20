//
//  MyPlansDataSource.swift
//  Wandr
//
//  Created by Kevin Shiflett on 8/14/19.
//  Copyright © 2019 Wandr Inc. All rights reserved.
//

import UIKit

class TableViewDataSource<Model>: NSObject, UITableViewDataSource {
    typealias CellConfigurator = (Model, UITableViewCell) -> Void
    
    var models: [Model]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [Model],
         reuseIdentifier: String,
         cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(
            withIdentifier: reuseIdentifier,
            for: indexPath
        )
        
        cellConfigurator(model, cell)
        
        return cell
    }
}

extension TableViewDataSource where Model == PlanChat {
    static func make(for messages: [PlanChat],
                     reuseIdentifier: String = "planChat") -> TableViewDataSource {
        return TableViewDataSource(models: messages, reuseIdentifier: reuseIdentifier) { (data, cell) in
            let itemCell: planPreviewCell = cell as! planPreviewCell
            itemCell.plan = data
        }
    }
}

extension TableViewDataSource where Model == SelectableContact {
    static func make(for contacts: [SelectableContact],
                     reuseIdentifier: String = "contact") -> TableViewDataSource {
        return TableViewDataSource(models: contacts, reuseIdentifier: reuseIdentifier) { (data, cell) in
            let itemCell: activeContactCell = cell as! activeContactCell
            itemCell.contact = data
        }
    }
}


class SectionedTableViewDataSource: NSObject {
    private let dataSources: [UITableViewDataSource]
    
    init(dataSources: [UITableViewDataSource]) {
        self.dataSources = dataSources
    }
}

extension SectionedTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let dataSource = dataSources[section]
        return dataSource.tableView(tableView, numberOfRowsInSection: 0)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = dataSources[indexPath.section]
        let indexPath = IndexPath(row: indexPath.row, section: indexPath.section)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
}
