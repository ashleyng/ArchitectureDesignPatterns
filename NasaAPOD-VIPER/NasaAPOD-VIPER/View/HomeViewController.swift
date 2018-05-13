//
//  HomeViewController.swift
//  NasaAPOD-VIPER
//
//  Created by Ashley Ng on 5/13/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit
import RxSwift

enum SectionType: Int {
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

class HomeViewController: UIViewController, HomeViewInteractor {

    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var photos = [NasaPhotoInfo]()
    fileprivate var favoritePhotos = [NasaPhotoInfo]()
    fileprivate let disposeBag = DisposeBag()
    fileprivate var presenter: HomeViewPresenterInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PhotoInfoCell", bundle: nil), forCellReuseIdentifier: "PhotoInfoCell")
        tableView.isHidden = true
        presenter?.fetchPhotos()
    }
    
    func attachPresenter(presenter: HomeViewPresenterInteractor) {
        self.presenter = presenter
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SectionType.favorite.rawValue {
            return SectionType.favorite.title
        } else {
            return SectionType.normal.title
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.favorite.rawValue {
            return favoritePhotos.count
        } else {
            return photos.count
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
        let photo = indexPath.section == SectionType.favorite.rawValue ? favoritePhotos[indexPath.row] : photos[indexPath.row]
        presenter?.detailsTapped(forPhoto: photo)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        presenter?.photoTapped(at: indexPath)
        return nil
    }
    
    fileprivate func movePhoto(at atIndexPath: IndexPath, to toIndexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.moveRow(at: atIndexPath, to: toIndexPath)
            self.tableView.endUpdates()
        }
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func favoritePhoto(at index: Int) {
        let photo = self.photos.remove(at: index)
        self.favoritePhotos.append(photo)
        movePhoto(at: IndexPath(row: index, section: 1), to: IndexPath(row: favoritePhotos.count - 1, section: 0))
    }
    
    func removePhotoFromFavorites(at index: Int) {
        let photo = self.favoritePhotos.remove(at: index)
        self.photos.append(photo)
        movePhoto(at: IndexPath(row: index, section: 0), to: IndexPath(row: photos.count - 1, section: 1))
    }
    
    func setPhotos(_ photos: [NasaPhotoInfo]) {
        DispatchQueue.main.async {
            self.photos = photos
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func displayFavoritePhoto(at index: Int) {
        let photo = favoritePhotos[index]
        self.displayPhoto(photo)
    }
    
    func displayNormalPhoto(at index: Int) {
        let photo = photos[index]
        self.displayPhoto(photo)
    }
    
    private func displayPhoto(_ photoInfo: NasaPhotoInfo) {
        NasaPhotoWireframe.createAndPresentDetailsView(photo: photoInfo, view: self)
    }
}

