//
//  RoutingState.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import ReSwift

struct RoutingState: StateType {
    var navigationState: RoutingDestination
    var photos: [String: [NasaPhotoInfo]]
    
    init(navigationState: RoutingDestination = .home, photos: [String: [NasaPhotoInfo]] = [PhotosType.favorite.key:[], PhotosType.normal.key:[]]) {
        self.navigationState = navigationState
        self.photos = photos
    }
}
