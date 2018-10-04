//
//  ApiFacade.swift
//  NasaAPOD-Facade
//
//  Created by Ashley Ng on 10/4/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import UIKit

struct ApiFacade {
    private let fetcher: NasaPhotoFetcher
    private let imageCache: ImageCache
    
    init(fetcher: NasaPhotoFetcher = NasaPhotoFetcher(), imageCache: ImageCache = ImageCache.shared ) {
        self.fetcher = fetcher
        self.imageCache = imageCache
    }
    
    func fetchPhotoInfo(completion: @escaping ([NasaPhotoInfo]) -> Void) {
        fetcher.fetchPhotos(count: 20, completion: completion)
    }
    
    func fetchImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        self.imageCache.imageFor(url: url, completion: completion)
    }
}
