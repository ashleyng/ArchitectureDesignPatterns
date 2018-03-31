//
//  NasaPhotoInfoModel.swift
//  NasaAPOD-MVC
//
//  Created by Ashley Ng on 3/31/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import UIKit

struct NasaPhotoInfo {
    let date: Date
    let description: String
    let hdPhotoUrl: URL
    let photoUrl: URL
    let title: String
    let copyright: String?
}
