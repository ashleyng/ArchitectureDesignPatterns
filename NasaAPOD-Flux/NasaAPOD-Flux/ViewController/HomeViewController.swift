//
//  HomeViewController.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit
import ReSwift

let FetchImageCount = 10

class HomeViewController: UIViewController {
    var tableDataSource: TableDataSource<PhotoInfoCell, NasaPhotoInfo>?
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        store.subscribe(self) {
            $0.select {
                $0.photosState
            }
        }
        
        store.dispatch(RoutingAction(destination: .home))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        store.unsubscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "PhotoInfoCell", bundle: nil), forCellReuseIdentifier: "PhotoInfoCell")
        tableView.delegate = self
        tableDataSource = TableDataSource(cellIdentifier: "PhotoInfoCell", sectionOneModel: [], sectionTwoModel: []) { (cell, model) in
            DispatchQueue.main.async {
                cell.configure(title: model.title, date: model.date)
                cell.startAnimating()
                ImageCache.shared.imageFor(url: model.photoUrl) { image in
                    cell.setImage(image: image)
                    cell.stopAnimating()
                    cell.setNeedsLayout()
                }
            }
            return cell
        }
        tableView.dataSource = tableDataSource
        store.dispatch(fetchPhotos)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let photoType = PhotosType(rawValue: indexPath.section) else {
            return
        }
        store.dispatch(RoutingAction(destination: .details(index: indexPath.row, photoType: photoType)))
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let photoType = PhotosType(rawValue: indexPath.section) else {
            return nil
        }
        tableView.beginUpdates()
        store.dispatch(TappedPhotoAction(photoIndexTapped: indexPath.row, photoTypeTapped: photoType))
        tableView.endUpdates()
        return nil
    }
}

extension HomeViewController: StoreSubscriber {
    func newState(state: PhotosState) {
        DispatchQueue.main.async {
            defer {
                self.loadingIndicator.isHidden = !state.showLoading
                state.showLoading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
                self.tableView.isHidden = state.showLoading
            }
            
            guard let sectionOneModel = state.photos[PhotosType.favorite.key],
                let sectionTwoModel = state.photos[PhotosType.normal.key] else {
                    return
            }
            self.tableDataSource?.sectionOneModel = sectionOneModel
            self.tableDataSource?.sectionTwoModel = sectionTwoModel
            self.tableView.reloadData()
        }
    }
}
