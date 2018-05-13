//
//  NasaPhotoWireframe.swift
//  NasaAPOD-VIPER
//
//  Created by Ashley Ng on 5/13/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import UIKit

class NasaPhotoWireframe: NasaPhotoRouter {
    
    class func createHomeView() -> UIViewController {
        let view: HomeViewInteractor & UIViewController = HomeViewController()
        let presenter: HomeViewPresenterOutput & HomeViewPresenterInteractor = HomeViewPresenterImp()
        let interactor: HomeViewPresenterInput = NasaPhotoDataInteractorImpl()
        
        view.attachPresenter(presenter: presenter)
        presenter.attachView(viewInteractor: view)
        presenter.attachInteractor(interactor: interactor)
        interactor.attachPressenter(presenter: presenter)
    
        return view
    }
    
    class func createAndPresentDetailsView(photo: NasaPhotoInfo, view: HomeViewInteractor) {
        guard let view = view as? UIViewController else {
            return
        }
        let detailsVC = NasaPhotoDetailViewController(photoInfo: photo)
        view.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
