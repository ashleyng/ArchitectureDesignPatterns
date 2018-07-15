//
//  NasaPhotoInfoModel.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation

struct NasaPhotoInfo {
    let date: Date
    let description: String
    let hdPhotoUrl: URL
    let photoUrl: URL
    let title: String
    let copyright: String?
}

enum PhotosType: Int {
    case favorite
    case normal
    
    var title: String {
        switch self {
        case .favorite:
            return "Favorites"
        case .normal:
            return "Photos"
        }
    }
}

struct PhotosState {
    var photos: [NasaPhotoInfo]
    var favoritePhotos: [NasaPhotoInfo]
    var showLoading: Bool
}
