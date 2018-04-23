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
    
}
