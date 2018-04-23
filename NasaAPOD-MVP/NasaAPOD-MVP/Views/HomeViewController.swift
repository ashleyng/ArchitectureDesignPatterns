//
//  HomeViewController.swift
//  NasaAPOD-MVP
//
//  Created by Ashley Ng on 4/22/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    var photos = [NasaPhotoInfo]()
    let presenter: HomeViewPresenter
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    init(presenter: HomeViewPresenter = HomeViewPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        
        presenter.attachView(view: self)
        presenter.fetchPhotos()
        
        tableView.register(UINib(nibName: "PhotoInfoCell", bundle: nil), forCellReuseIdentifier: "PhotoInfoCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    deinit {
        self.presenter.detachView()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = NasaPhotoDetailViewController(photoInfo: photos[indexPath.row])
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension HomeViewController: HomeViewInteractor {
    func startLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator.startAnimating()
            self.loadingIndicator.isHidden = false
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
        }
    }
    
    func setPhotos(_ photos: [NasaPhotoInfo]) {
        DispatchQueue.main.async {
            self.photos = photos
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    
}
