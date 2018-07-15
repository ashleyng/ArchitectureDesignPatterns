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
    var photos = [NasaPhotoInfo]()
    var favoritePhotos = [NasaPhotoInfo]()
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

//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        let detailsVC = NasaPhotoDetailViewController(photoInfo: photos[indexPath.row])
//        self.navigationController?.pushViewController(detailsVC, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.beginUpdates()
        if indexPath.section == PhotosType.normal.rawValue {
            store.dispatch(FavoritePhotoAction(photoIndexToFavorite: indexPath.row))
        } else {
            store.dispatch(UnfavoritePhotoAction(photoIndexToUnfavorite: indexPath.row))
        }
        tableView.endUpdates()
        return nil
    }
}

extension HomeViewController: StoreSubscriber {
    func newState(state: PhotosState) {
        DispatchQueue.main.async {
            self.tableDataSource?.sectionOneModel = state.favoritePhotos
            self.tableDataSource?.sectionTwoModel = state.photos
            self.tableView.reloadData()
            
            if state.showLoading {
                self.loadingIndicator.isHidden = false
                self.loadingIndicator.startAnimating()
                self.tableView.isHidden = true
            } else {
                self.loadingIndicator.isHidden = true
                self.loadingIndicator.stopAnimating()
                self.tableView.isHidden = false
            }
        }
    }
}
