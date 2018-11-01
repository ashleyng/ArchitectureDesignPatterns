//
//  HomeViewController.swift
//  NasaAPOD-Facade
//
//  Created by Ashley Ng on 10/4/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    private var photos = [NasaPhotoInfo]()
    private var favoritePhotos = [NasaPhotoInfo]()
    private let facade: ApiFacade
    
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
    
    init(facade: ApiFacade = ApiFacade()) {
        self.facade = facade
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        tableView.isHidden = true
        
        facade.fetchPhotoInfo(completion: { [weak self] photoInfo in
            DispatchQueue.main.async {
                self?.photos = photoInfo
                self?.tableView.isHidden = false
                self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.isHidden = true
                self?.tableView.reloadData()
            }
        })
        
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
            facade.fetchImage(for: photoInfo.photoUrl) { image in
                DispatchQueue.main.async {
                    guard let image = image else {
                        cell.stopAnimating()
                        return
                    }
                    cell.setImage(image: image)
                    cell.stopAnimating()
                    cell.setNeedsLayout()
                }
            }
            return cell
        }
        return PhotoInfoCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        var photo: NasaPhotoInfo
        if indexPath.section == SectionType.normal.rawValue {
            photo = photos[indexPath.row]
        } else {
            photo = favoritePhotos[indexPath.row]
        }
        let detailsVC = NasaPhotoDetailViewController(photoInfo: photo, apiFacade: facade)
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
