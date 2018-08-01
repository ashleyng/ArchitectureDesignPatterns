//
//  AppReducer.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(photosState: favoritePhotoReducer(action: action, state: state?.photosState),
                    routingState: routingReducer(action: action, state: state?.routingState))
}
