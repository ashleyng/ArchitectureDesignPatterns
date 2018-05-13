//
//  NasaPhotoInfoModel.swift
//  NasaAPOD-MVC
//
//  Created by Ashley Ng on 3/31/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation

class NasaPhotoInfo {
    let date: Date
    let description: String
    let hdPhotoUrl: URL
    let photoUrl: URL
    let title: String
    let copyright: String?
    var favorite: Bool
    
    init(date: Date,
         description: String,
         hdPhotoUrl: URL,
         photoUrl: URL,
         title: String,
         copyright: String?,
         favorite: Bool = false) {
        self.date = date
        self.description = description
        self.hdPhotoUrl = hdPhotoUrl
        self.photoUrl = photoUrl
        self.title = title
        self.copyright = copyright
        self.favorite = favorite
    }
}
