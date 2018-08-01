//
//  RoutingReducer.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import ReSwift

func routingReducer(action: Action, state: RoutingState?) -> RoutingState {
    var state = state ?? RoutingState()
    switch action {
    case let routingAction as RoutingAction:
        state.navigationState = routingAction.destination
    case let setPhotosAction as SetPhotoAction:
        state.photos[PhotosType.normal.key] = setPhotosAction.photos
    case let photoTapped as TappedPhotoAction:
        state.photos = updatePhotos(index: photoTapped.photoIndexTapped, typeTapped: photoTapped.photoTypeTapped, photos: state.photos)
    default:
        break
    }
    return state
}
