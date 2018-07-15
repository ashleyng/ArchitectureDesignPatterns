//
//  TableDataSource.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit

final class TableDataSource<V, T> : NSObject, UITableViewDataSource where V: UITableViewCell {
    
    typealias CellConfiguration = (V, T) -> V
    
    var sectionOneModel: [T]
    var sectionTwoModel: [T]
    private let configureCell: CellConfiguration
    private let cellIdentifier: String
    
    init(cellIdentifier: String, sectionOneModel: [T], sectionTwoModel: [T], configureCell: @escaping CellConfiguration) {
        self.sectionOneModel = sectionOneModel
        self.sectionTwoModel = sectionTwoModel
        self.cellIdentifier = cellIdentifier
        self.configureCell = configureCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == PhotosType.favorite.rawValue {
            return PhotosType.favorite.title
        } else {
            return PhotosType.normal.title
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == PhotosType.favorite.rawValue {
            return sectionOneModel.count
        }
        return sectionTwoModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? V
        
        guard let currentCell = cell else {
            fatalError("Identifier or class not registered with this table view")
        }
        let model: T
        if indexPath.section == PhotosType.normal.rawValue {
            model = sectionTwoModel[indexPath.row]
        } else {
            model = sectionOneModel[indexPath.row]
        }
        
        return configureCell(currentCell, model)
    }
}
