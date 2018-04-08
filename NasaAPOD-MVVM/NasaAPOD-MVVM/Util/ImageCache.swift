//
//  ImageCache.swift
//  NasaAPOD-MVVM
//
//  Created by Ashley Ng on 4/7/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ImageDataCache {
    
    enum ImageCacheError: Error {
        case failedDownload
    }
    static let shared = ImageDataCache()
    
    private let cache = NSCache<NSString, NSData>()
    
    func imageDataFor(url: URL) -> Observable<NSData> {
        return Observable.create { subscriber -> Disposable in
            DispatchQueue.global().async {
                if let imageDataInCache = self.cache.object(forKey: url.absoluteString as NSString) {
                    subscriber.onNext(imageDataInCache)
                    subscriber.onCompleted()
                }
                if let data = NSData(contentsOf: url) {
                    self.cache.setObject(data, forKey: url.absoluteString as NSString)
                    subscriber.onNext(data)
                    subscriber.onCompleted()
                } else {
                    subscriber.onError(ImageCacheError.failedDownload)
                }
            }
            return Disposables.create()
        }
    }
}

