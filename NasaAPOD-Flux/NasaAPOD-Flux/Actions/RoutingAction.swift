//
//  RoutingAction.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import ReSwift

struct RoutingAction: Action {
    let destination: RoutingDestination
    let photoIndexTapped: Int?
    let photoTypeTapped: PhotosType?
    
    init(destination: RoutingDestination, photoIndexTapped: Int? = nil, photoTypeTapped: PhotosType? = nil) {
        self.destination = destination
        self.photoIndexTapped = photoIndexTapped
        self.photoTypeTapped = photoTypeTapped
    }
}
