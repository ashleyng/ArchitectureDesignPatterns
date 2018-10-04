//
//  ApiFetcher.swift
//  NasaAPOD-Facade
//
//  Created by Ashley Ng on 10/4/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate let ApiKey = ""
fileprivate let DefaultPhotoCount = 20

class NasaPhotoFetcher {
    
    let baseEndpoint = "https://api.nasa.gov/planetary/apod?api_key=\(ApiKey)"
    let session = URLSession.shared
    var dataTask: URLSessionDataTask?
    
    func fetchPhotos(count: Int, completion: @escaping ([NasaPhotoInfo]) -> Void) {
        dataTask?.cancel()
        let countUrlString = "\(baseEndpoint)&count=\(count)"
        let countUrl = URL(string: countUrlString)!
        let request = URLRequest(url: countUrl)
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let `self` = self else { return completion([]) }
            defer { self.dataTask = nil }
            if let error = error  {
                
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let results = jsonObject as? [[String: Any]] else {
                        return completion([])
                }
                let model = self.mapDataToModel(data: results)
                return completion(model)
            }
        }
        dataTask?.resume()
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

