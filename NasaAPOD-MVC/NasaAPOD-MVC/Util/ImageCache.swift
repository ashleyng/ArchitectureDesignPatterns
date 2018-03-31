//
//  ImageCache.swift
//  NasaAPOD-MVC
//
//  Created by Ashley Ng on 3/31/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ImageCache {
    
    enum ImageCacheError: Error {
        case failedDownload
    }
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    func imageFor(url: URL) -> Observable<UIImage> {
        return Observable.create { subscriber -> Disposable in
            DispatchQueue.global().async {
                if let imageInCache = self.cache.object(forKey: url.absoluteString as NSString) {
                    subscriber.onNext(imageInCache)
                    subscriber.onCompleted()
                }
                if let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: url.absoluteString as NSString)
                    subscriber.onNext(image)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(ImageCacheError.failedDownload)
                }
            }
            return Disposables.create()
        }
    }
}
