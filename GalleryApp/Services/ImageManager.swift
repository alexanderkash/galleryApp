//
//  ImageManager.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/7/21.
//

import UIKit

class ImageManager {
    
    static let shared = ImageManager()
    
    let cache = URLCache.shared
    
    private init() {}
    
    func loadImage(urlString: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let fileCachePath = FileManager.default.temporaryDirectory
            .appendingPathComponent(url.lastPathComponent, isDirectory: false)
    
        if let data =  try? Data(contentsOf: fileCachePath),
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                completion(.success(image))
            }
           return
        }
        
        downloadData(url: url, toFile: fileCachePath) { error in
            do {
                let data = try Data(contentsOf: fileCachePath)
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func downloadData(url: URL, toFile file: URL, completion: @escaping (Error?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard let tempURL = tempURL else { completion(error); return }
            
            do {
                if FileManager.default.fileExists(atPath: file.path) {
                    try FileManager.default.removeItem(at: file)
                }
                try FileManager.default.copyItem(at: tempURL, to: file)
                completion(nil)
            }
            catch {
                completion(error)
            }
        }
        task.resume()
    }
    
    
    func downloadImage(imageURL: URL) -> UIImage {
        let request = URLRequest(url: imageURL)
        var downloadedImage = UIImage()
        DispatchQueue.global().async {
            let dataTask = URLSession.shared.dataTask(with: imageURL) {data, response, _ in
                if let data = data {
                    let cachedData = CachedURLResponse(response: response!, data: data)
                    self.cache.storeCachedResponse(cachedData, for: request)
                    downloadedImage = UIImage(data: data)!
                }
            }
            dataTask.resume()
        }
        return downloadedImage
    }
    
    func loadImageFromCache(imageURL: URL) -> UIImage {
        let request = URLRequest(url: imageURL)
        var loadedImage = UIImage()
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = self.cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    loadedImage = image
                }
            }
        }
        return loadedImage
    }
    
}
