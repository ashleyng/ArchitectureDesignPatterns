//
//  FavoriteAction.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import ReSwift

struct FavoritePhotoAction: Action {
    let photoIndexToFavorite: Int
}

struct UnfavoritePhotoAction: Action {
    let photoIndexToUnfavorite: Int
}

struct TappedPhotoAction: Action {
    let photoIndexTapped: Int
    let photoSectionTapped: Int
}
