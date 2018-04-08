//
//  HomeViewModel.swift
//  NasaAPOD-MVVM
//
//  Created by Ashley Ng on 4/7/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import RxSwift

let FetchImageCount = 10

class HomeViewModel {
    private let photoFetcher: NasaPhotoFetcher
    private let disposeBag = DisposeBag()
    
    private var photoCells = [PhotoInfoViewModel]()
    var count: Int {
        return photoCells.count
    }
    
    private let isLoading: Variable<Bool> = Variable(false)
    var rx_isLoading: Observable<Bool> {
        return isLoading.asObservable()
    }
    
    init(photoFetcher: NasaPhotoFetcher = NasaPhotoFetcher()) {
        self.photoFetcher = photoFetcher
    }
    
    func fetchPhotos() {
        isLoading.value = true
        photoFetcher.fetchPhotos(count: FetchImageCount)
            .map { (photos: [NasaPhotoInfo]) -> [PhotoInfoViewModel] in
                return photos.map { infoModel in
                    return self.createCellViewModel(photoInfoModel: infoModel)
                }
            }
            .subscribe(onNext: { [weak self] photoViewModels in
                self?.photoCells = photoViewModels
                self?.isLoading.value = false
            })
            .disposed(by: disposeBag)
    }
    
    func getCellViewModel(at index: Int) -> PhotoInfoViewModel {
        return photoCells[index]
    }
    
    private func createCellViewModel(photoInfoModel: NasaPhotoInfo) -> PhotoInfoViewModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        return PhotoInfoViewModel(date: dateFormatter.string(from: photoInfoModel.date),
                                  photoUrl: photoInfoModel.photoUrl,
                                  title: photoInfoModel.title,
                                  description: photoInfoModel.description)
    }
}
