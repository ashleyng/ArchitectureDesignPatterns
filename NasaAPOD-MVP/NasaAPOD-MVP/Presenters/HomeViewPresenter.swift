//
//  HomeViewPresenter.swift
//  NasaAPOD-MVP
//
//  Created by Ashley Ng on 4/19/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewInteractor: class {
    func startLoading()
    func stopLoading()
    func setPhotos(_ photos: [NasaPhotoInfo])
    func favoritePhoto(at index: Int)
    func removePhotoFromFavorites(at index: Int)
}

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

let FetchImageCount = 10
class HomeViewPresenter {
    
    weak private var viewInteractor: HomeViewInteractor?
    private let photoFetcher: NasaPhotoFetcher
    private let disposeBag = DisposeBag()
    
    init(photoFetcher: NasaPhotoFetcher = NasaPhotoFetcher()) {
        self.photoFetcher = photoFetcher
    }
    
    func attachView(view: HomeViewInteractor) {
        self.viewInteractor = view
    }
    
    func detachView() {
        self.viewInteractor = nil
    }
    
    func fetchPhotos() {
        viewInteractor?.startLoading()
        photoFetcher.fetchPhotos(count: FetchImageCount)
            .subscribe(onNext: { [weak self] photos in
                self?.viewInteractor?.setPhotos(photos)
                self?.viewInteractor?.stopLoading()
            })
            .disposed(by: disposeBag)
    }
    
    func photoTapped(at indexPath: IndexPath) {
        if indexPath.section == SectionType.favorite.rawValue {
            viewInteractor?.removePhotoFromFavorites(at: indexPath.row)
        } else {
            viewInteractor?.favoritePhoto(at: indexPath.row)
        }
    }
    
}
