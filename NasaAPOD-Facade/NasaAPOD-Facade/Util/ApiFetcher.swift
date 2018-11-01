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
    
    func fetchPhotos(count: Int, completion: @escaping ([[String: Any]]) -> Void) {
        dataTask?.cancel()
        let countUrlString = "\(baseEndpoint)&count=\(count)"
        let countUrl = URL(string: countUrlString)!
        let request = URLRequest(url: countUrl)
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let `self` = self else { return completion([[:]]) }
            defer { self.dataTask = nil }
            if let error = error  {
                return completion([[:]])
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let results = jsonObject as? [[String: Any]] else {
                        return completion([[:]])
                }
                return completion(results)
            }
        }
        dataTask?.resume()
    }
    
    
}

