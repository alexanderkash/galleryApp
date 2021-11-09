//
//  NetworkService.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/4/21.
//

import Foundation

struct PhotosInfoLoader {
    
    static let shared = PhotosInfoLoader()

    private init() {}
    
    func loadPhotosInfo(completion: @escaping (Result<[PhotoInfo], Error>) -> Void) {
        let urlString = "http://dev.bgsoft.biz/task/"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Some  error", error)
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                do {
                    let result = try JSONDecoder().decode(DecodedArray<PhotoInfo>.self, from: data)
                    let photos = result.compactMap{ $0 }
                    completion(.success(photos))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }
        task.resume()
    }
}

