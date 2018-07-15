//
//  FetchPhotosAction.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import ReSwift

func fetchPhotos(state: AppState, store: Store<AppState>) -> FetchPhotosAction {
    NasaPhotoFetcher.fetchPhotos(count: FetchImageCount) { photos in
        store.dispatch(SetPhotoAction(photos: photos))
    }
    return FetchPhotosAction()
}

struct FetchPhotosAction: Action {
    
}

struct SetPhotoAction: Action {
    let photos: [NasaPhotoInfo]
}
