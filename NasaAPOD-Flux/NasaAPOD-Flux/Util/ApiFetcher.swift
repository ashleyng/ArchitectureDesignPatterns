//
//  ApiFetcher.swift
//  NasaAPOD-Flux
//
//  Created by Ashley Ng on 7/14/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation

fileprivate let ApiKey = "AtAcPJ2CbIP8QHf9LSOiQ9kF5tyqWhSh6Y0XKfWt"
fileprivate let DefaultPhotoCount = 20

class NasaPhotoFetcher {
    
    static func fetchPhotos(count: Int, completion: @escaping ([NasaPhotoInfo]) -> Void) {
        let baseEndpoint = "https://api.nasa.gov/planetary/apod?api_key=\(ApiKey)"
        let session = URLSession.shared
        
        let countUrlString = "\(baseEndpoint)&count=\(count)"
        let countUrl = URL(string: countUrlString)!
        let request = URLRequest(url: countUrl)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion([])
                return
            }
            
            do {
                guard let data = data,
                    let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let results = jsonObject as? [[String: Any]] else {
                        completion([])
                        return
                }
                
                let photos:[NasaPhotoInfo] = results.compactMap { object -> NasaPhotoInfo? in
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
                completion(photos)
            }
        }
        task.resume()
    }
}

