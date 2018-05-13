//
//  HomeViewPresenter.swift
//  NasaAPOD-VIPER
//
//  Created by Ashley Ng on 5/13/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation

class HomeViewPresenterImp: HomeViewPresenterOutput, HomeViewPresenterInteractor {
    private weak var viewInteractor: HomeViewInteractor?
    private var interactor: HomeViewPresenterInput?
    
    func fetchPhotos() {
        viewInteractor?.startLoading()
        interactor?.getPhotos()
    }
    
    func attachView(viewInteractor: HomeViewInteractor) {
        self.viewInteractor = viewInteractor
    }
    
    func attachInteractor(interactor: HomeViewPresenterInput) {
        self.interactor = interactor
    }
    
    deinit {
        self.viewInteractor = nil
        self.interactor = nil
    }
    
    func didRetrievePhotos(_ photos: [NasaPhotoInfo]) {
        viewInteractor?.stopLoading()
        viewInteractor?.setPhotos(photos)
    }
    
    func photoTapped(at indexPath: IndexPath) {
        if indexPath.section == SectionType.favorite.rawValue {
            viewInteractor?.removePhotoFromFavorites(at: indexPath.row)
        } else {
            viewInteractor?.favoritePhoto(at: indexPath.row)
        }
    }
    
    func detailsTapped(forPhoto photo: NasaPhotoInfo) {
        NasaPhotoWireframe.createAndPresentDetailsView(photo: photo, view: viewInteractor)
    }
}
