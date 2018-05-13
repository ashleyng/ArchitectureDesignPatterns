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
    
    private enum SectionType: Int {
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
    
    private var photoCells = [PhotoInfoViewModel]()
    private var favoritePhotosCells = [PhotoInfoViewModel]()
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
    
    func titleForSection(_ section: Int) -> String {
        if section == SectionType.favorite.rawValue {
            return SectionType.favorite.title
        } else {
            return SectionType.normal.title
        }
    }
    
    func photosInSection(_ section: Int) -> Int {
        if section == SectionType.favorite.rawValue {
            return favoritePhotosCells.count
        } else {
            return photoCells.count
        }
    }
    
    func photoTapped(at indexPath: IndexPath) -> IndexPath {
        if indexPath.section == SectionType.favorite.rawValue {
            return self.unfavoritePhoto(at: indexPath.row)
        } else {
            return self.favoritePhoto(at: indexPath.row)
        }
    }
    
    private func favoritePhoto(at index: Int) -> IndexPath {
        let photo = photoCells[index]
        favoritePhotosCells.append(photo)
        photoCells.remove(at: index)
        photo.favorite = !photo.favorite
        return IndexPath(row: favoritePhotosCells.count-1, section: SectionType.favorite.rawValue)
    }
    
    private func unfavoritePhoto(at index: Int) -> IndexPath {
        let photo = favoritePhotosCells[index]
        photoCells.append(photo)
        favoritePhotosCells.remove(at: index)
        photo.favorite = !photo.favorite
        return IndexPath(row: photoCells.count-1, section: SectionType.normal.rawValue)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PhotoInfoViewModel {
        if indexPath.section == SectionType.favorite.rawValue {
            return favoritePhotosCells[indexPath.row]
        } else {
            return photoCells[indexPath.row]
        }
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
