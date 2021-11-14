//
//  NetworkService.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/4/21.
//

import Foundation

struct PhotoInfoLoader {
    
    private let photosInfoUrl = "http://dev.bgsoft.biz/task/"
    
    func loadPhotosInfo(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let url = URL(string: photosInfoUrl) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(DecodedArray<Photo>.self, from: data)
                let photos = result.compactMap{ $0 }
                DispatchQueue.main.async {
                    completion(.success(photos))
                }
            } catch let jsonError {
                print("Failed to decode JSON", jsonError.localizedDescription)
                completion(.failure(jsonError))
            }
        }
        task.resume()
    }
}

