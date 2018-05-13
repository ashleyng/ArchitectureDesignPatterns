//
//  PhotoInfoCellViewModel.swift
//  NasaAPOD-MVVM
//
//  Created by Ashley Ng on 4/7/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import RxSwift

class PhotoInfoViewModel {
    let date: String
    let photoUrl: URL
    let title: String
    let description: String
    var favorite: Bool = false
    
    private let isLoading: Variable<Bool> = Variable(false)
    var rx_isLoading: Observable<Bool> {
        return isLoading.asObservable()
    }
    
    init(date: String, photoUrl: URL, title: String, description: String) {
        self.date = date
        self.photoUrl = photoUrl
        self.title = title
        self.description = description
    }
    
    func imageData() -> Observable<NSData> {
        isLoading.value = true
        return ImageDataCache.shared.imageDataFor(url: photoUrl)
            .map{ data in
                self.isLoading.value = false
                return data
            }
    }
}
