//
//  HomeViewController.swift
//  NasaAPOD-MVVM
//
//  Created by Ashley Ng on 4/7/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit
import RxSwift


class HomeViewController: UIViewController {
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchPhotos()
        viewModel.rx_isLoading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                    self?.loadingIndicator.isHidden = false
                    self?.tableView.isHidden = true
                } else {
                    self?.loadingIndicator.stopAnimating()
                    self?.loadingIndicator.isHidden = true
                    self?.tableView.isHidden = false
                    self?.tableView.reloadData()
                }
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photosInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoInfoCell", for: indexPath) as? PhotoInfoCell {
            let cellViewModel = viewModel.getCellViewModel(at: indexPath)
            cell.configure(with: cellViewModel)
            return cell
        }
        return PhotoInfoCell()
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let photoInfoViewModel = viewModel.getCellViewModel(at: indexPath)
        let detailsVC = NasaPhotoDetailViewController(viewModel: photoInfoViewModel)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.beginUpdates()
        let newIndexPath = viewModel.photoTapped(at: indexPath)
        tableView.moveRow(at: indexPath, to: newIndexPath)
        tableView.endUpdates()
        return nil
    }
}

