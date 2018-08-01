//
//  FavoritePhotoReducer.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import ReSwift

func favoritePhotoReducer(action: Action, state: PhotosState?) -> PhotosState {
    let emptyPhotos:[String: [NasaPhotoInfo]] = [PhotosType.favorite.key:[], PhotosType.normal.key:[]]
    var state = state ?? PhotosState(photos: emptyPhotos,showLoading: false)
    
    switch action {
    case _ as FetchPhotosAction:
        state = PhotosState(photos: emptyPhotos, showLoading: true)
    case let setPhotos as SetPhotoAction:
        state.photos[PhotosType.normal.key] = setPhotos.photos
        state.showLoading = false
    case let photoTapped as TappedPhotoAction:
        state.photos = updatePhotos(index: photoTapped.photoIndexTapped, typeTapped: photoTapped.photoTypeTapped, photos: state.photos)
    default: break
    }
    return state
}

func updatePhotos(index: Int, typeTapped: PhotosType, photos: [String: [NasaPhotoInfo]]) -> [String: [NasaPhotoInfo]] {
    var photosCopy = photos
    guard let photoRemoved = photosCopy[typeTapped.key]?.remove(at: index) else {
        return photos
    }
    photosCopy[typeTapped.opposite.key]?.append(photoRemoved)
    return photosCopy
}

