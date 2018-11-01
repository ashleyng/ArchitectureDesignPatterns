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
    private let imageCache = NSCache<NSString, UIImage>()
    enum ImageCacheError: Error {
        case failedDownload
    }
    
    init(fetcher: NasaPhotoFetcher = NasaPhotoFetcher()) {
        self.fetcher = fetcher
    }
    
    func fetchPhotoInfo(completion: @escaping ([NasaPhotoInfo]) -> Void) {
        fetcher.fetchPhotos(count: 20) { data in
            let convertedData = self.mapDataToModel(data: data)
            completion(convertedData)
        }
    }
    
    func fetchImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let imageInCache = self.imageCache.object(forKey: url.absoluteString as NSString) {
                completion(imageInCache)
            }
            if let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    private func mapDataToModel(data: [[String: Any]]) -> [NasaPhotoInfo] {
        return data.compactMap { object in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-mm-dd"
            guard let dateString = object["date"] as? String,
                let description = object["explanation"] as? String,
                let hdUrlString = object["hdurl"] as? String,
                let title = object["title"] as? String,
                let urlString = object["url"] as? String else {
                    return nil
            }
            guard let date = dateFormatter.date(from: dateString),
                let hdUrl = URL(string: hdUrlString),
                let url = URL(string: urlString) else {
                    return nil
            }
            let copyright: String? = object["copyright"] as? String
            return NasaPhotoInfo(date: date,
                                 description: description,
                                 hdPhotoUrl: hdUrl,
                                 photoUrl: url,
                                 title: title,
                                 copyright: copyright)
        }
    }
}
