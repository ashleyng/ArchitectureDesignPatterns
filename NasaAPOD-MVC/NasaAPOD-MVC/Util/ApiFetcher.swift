//
//  ApiFetcher.swift
//  NasaAPOD-MVC
//
//  Created by Ashley Ng on 3/31/18.
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
    
    func fetchPhotos(count: Int) -> Observable<[[String: Any]]> {
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
    }
}
