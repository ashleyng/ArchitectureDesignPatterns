//
//  NasaPhotoInfoModel.swift
//  NasaAPOD-MVVM
//
//  Created by Ashley Ng on 4/7/18.
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
