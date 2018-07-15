//
//  FavoritePhotoReducer.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import ReSwift

func favoritePhotoReducer(action: Action, state: PhotosState?) -> PhotosState {
    var state = state ?? PhotosState(photos: [], favoritePhotos: [], showLoading: false)
    
    switch action {
    case _ as FetchPhotosAction:
        state = PhotosState(photos: [], favoritePhotos: [], showLoading: true)
    case let setPhotos as SetPhotoAction:
        state.photos = setPhotos.photos
        state.showLoading = false
    case let favoritePhoto as FavoritePhotoAction:
        let photoToFavorite = state.photos[favoritePhoto.photoIndexToFavorite]
        state.photos = removeFromPhotos(index: favoritePhoto.photoIndexToFavorite, photos: state.photos)
        state.favoritePhotos = addPhoto(photo: photoToFavorite, photos: state.favoritePhotos)
    case let unfavoritePhoto as UnfavoritePhotoAction:
        let photoToUnfavorite = state.favoritePhotos[unfavoritePhoto.photoIndexToUnfavorite]
        state.favoritePhotos = removeFromPhotos(index: unfavoritePhoto.photoIndexToUnfavorite, photos: state.favoritePhotos)
        state.photos = addPhoto(photo: photoToUnfavorite, photos: state.photos)
    default: break
    }
    return state
}


func removeFromPhotos(index: Int, photos: [NasaPhotoInfo]) -> [NasaPhotoInfo] {
    var photosCopy = photos
    photosCopy.remove(at: index)
    return photosCopy
}

func addPhoto(photo: NasaPhotoInfo, photos: [NasaPhotoInfo]) -> [NasaPhotoInfo] {
    var photosCopy = photos
    photosCopy.append(photo)
    return photosCopy
}

