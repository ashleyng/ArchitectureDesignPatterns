//
//  ViewController.swift
//  NasaAPOD-MVC
//
//  Created by Ashley Ng on 3/31/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit
import RxSwift

let FetchImageCount = 10

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    var photos = [NasaPhotoInfo]()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        tableView.isHidden = true
        
        NasaPhotoFetcher().fetchPhotos(count: FetchImageCount)
            .map { (data: [[String: Any]]) -> [NasaPhotoInfo] in
                return data.flatMap { object in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-mm-dd"
                    guard let dateString = object["date"] as? String,
                        let description = object["explanation"] as? String,
                        let hdUrlString = object["hdurl"] as? String,
                        let title = object["title"] as? String,
                        let urlString = object["url"] as? String else {
                            return nil
                    }
                    guard let date = dateFormatter.date(from: dateString),
                        let hdUrl = URL(string: hdUrlString),
                        let url = URL(string: urlString) else {
                            return nil
                    }
                    let copyright: String? = object["copyright"] as? String
                    return NasaPhotoInfo(date: date,
                                         description: description,
                                         hdPhotoUrl: hdUrl,
                                         photoUrl: url,
                                         title: title,
                                         copyright: copyright)
                }
            }
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
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
