//
//  ApiFetcher.swift
//  NasaAPOD-MVP
//
//  Created by Ashley Ng on 4/19/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate let ApiKey = ""
fileprivate let DefaultPhotoCount = 5

class NasaPhotoFetcher {
    
    let baseEndpoint = "https://api.nasa.gov/planetary/apod?api_key=\(ApiKey)"
    let session = URLSession.shared
    
    func fetchPhotos(count: Int) -> Observable<[NasaPhotoInfo]> {
        let countUrlString = "\(baseEndpoint)&count=\(count)"
        let countUrl = URL(string: countUrlString)!
        let request = URLRequest(url: countUrl)
        return session.rx.response(request: request)
            .map { data, response -> [[String: Any]] in
                guard let jsonObject = try? JSONSerialization.jsonObject(with: response, options: []),
                    let results = jsonObject as? [[String: Any]] else {
                        return []
                }
                return results
            }
            .map { (data: [[String: Any]]) -> [NasaPhotoInfo] in
                return data.flatMap { object in
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
}
