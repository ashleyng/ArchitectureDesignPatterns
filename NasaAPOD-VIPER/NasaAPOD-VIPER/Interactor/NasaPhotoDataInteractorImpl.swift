//
//  NasaPhotoInteractor.swift
//  NasaAPOD-VIPER
//
//  Created by Ashley Ng on 5/13/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import RxSwift

let FetchImageCount = 20
class NasaPhotoDataInteractorImpl: HomeViewPresenterInput {
    private let photoFetcher: NasaPhotoFetcher
    private weak var presenter: HomeViewPresenterOutput?
    private let disposeBag = DisposeBag()
    
    init(photoFetcher: NasaPhotoFetcher = NasaPhotoFetcher()) {
        self.photoFetcher = photoFetcher
    }
    
    func attachPressenter(presenter: HomeViewPresenterOutput) {
        self.presenter = presenter
    }
    
    deinit {
        self.presenter = nil
    }
    
    func getPhotos() {
        photoFetcher.fetchPhotos(count: FetchImageCount)
            .subscribe(onNext: { [weak self] photos in
                self?.presenter?.didRetrievePhotos(photos)
            }, onError: { [weak self] error in
                self?.presenter?.didRetrievePhotos([])
            })
            .disposed(by: disposeBag)
    }
}
