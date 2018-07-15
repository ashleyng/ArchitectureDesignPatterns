//
//  ImageCache.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    
    enum ImageCacheError: Error {
        case failedDownload
    }
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    func imageFor(url: URL, completion: @escaping ((UIImage) -> Void)) {
        DispatchQueue.global().async {
            if let imageInCache = self.cache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async {
                    completion(imageInCache)
                }
            }
            if let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}

