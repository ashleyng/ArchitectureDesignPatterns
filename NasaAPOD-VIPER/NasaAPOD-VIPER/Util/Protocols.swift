//
//  Protocols.swift
//  NasaAPOD-VIPER
//
//  Created by Ashley Ng on 5/13/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import UIKit

protocol NasaPhotoRouter: class {
    static func createHomeView() -> UIViewController
}

// View -> Presenter
protocol HomeViewPresenterInteractor: class {
    func fetchPhotos()
    func attachView(viewInteractor: HomeViewInteractor)
    func attachInteractor(interactor: HomeViewPresenterInput)
    func photoTapped(at indexPath: IndexPath)
    func detailsTapped(forPhoto photo: NasaPhotoInfo)
}

// Presenter -> View
protocol HomeViewInteractor: class {
    func attachPresenter(presenter: HomeViewPresenterInteractor)
    func startLoading()
    func stopLoading()
    func setPhotos(_ photos: [NasaPhotoInfo])
    func favoritePhoto(at index: Int)
    func removePhotoFromFavorites(at index: Int)
    func displayFavoritePhoto(at index: Int)
    func displayNormalPhoto(at index: Int)
}

// Presenter -> Interactor
protocol HomeViewPresenterInput: class {
    func getPhotos()
    func attachPressenter(presenter: HomeViewPresenterOutput)
}

// Interactor -> Presenter
protocol HomeViewPresenterOutput: class {
    func didRetrievePhotos(_ photos: [NasaPhotoInfo])
}

