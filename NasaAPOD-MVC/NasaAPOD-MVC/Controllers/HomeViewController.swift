//
//  HomeViewController.swift
//  NasaAPOD-MVC
//
//  Created by Ashley Ng on 3/31/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit
import RxSwift

let FetchImageCount = 10

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    var photos = [NasaPhotoInfo]()
    var favoritePhotos = [NasaPhotoInfo]()
    
    fileprivate enum SectionType: Int {
        case favorite
        case normal
        
        var title: String {
            switch self {
            case .favorite:
                return "Favorites"
            case .normal:
                return "Photos"
            }
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        tableView.isHidden = true
        
        NasaPhotoFetcher().fetchPhotos(count: FetchImageCount)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] photoInfo in
                self?.photos = photoInfo
                self?.tableView.isHidden = false
                self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.isHidden = true
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        tableView.register(UINib(nibName: "PhotoInfoCell", bundle: nil), forCellReuseIdentifier: "PhotoInfoCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.favorite.rawValue {
            return favoritePhotos.count
        }
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SectionType.favorite.rawValue {
            return SectionType.favorite.title
        } else {
            return SectionType.normal.title
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoInfoCell", for: indexPath) as? PhotoInfoCell {
            let photoInfo = photos[indexPath.row]
            cell.configure(title: photoInfo.title, date: photoInfo.date)
            cell.startAnimating()
            ImageCache.shared.imageFor(url: photoInfo.photoUrl)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { image in
                    cell.setImage(image: image)
                    cell.stopAnimating()
                    cell.setNeedsLayout()
                },onError: { error in
                    cell.stopAnimating()
                })
                .disposed(by: disposeBag)
            return cell
        }
        return PhotoInfoCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let detailsVC = NasaPhotoDetailViewController(photoInfo: photos[indexPath.row])
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.beginUpdates()
        if indexPath.section == SectionType.normal.rawValue {
            let photo = photos[indexPath.row]
            photos.remove(at: indexPath.row)
            favoritePhotos.append(photo)
            let lastRow = tableView.numberOfRows(inSection: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: lastRow, section: 0))
            photo.favorite = !photo.favorite
        } else {
            let photo = favoritePhotos[indexPath.row]
            favoritePhotos.remove(at: indexPath.row)
            photos.append(photo)
            let lastRow = tableView.numberOfRows(inSection: 1)
            tableView.moveRow(at: indexPath, to: IndexPath(row: lastRow, section: 1))
            photo.favorite = !photo.favorite
        }
        tableView.endUpdates()
        return nil
    }
}
