//
//  ImageManager.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/7/21.
//

import UIKit

struct ImageLoader {
    
    static let shared = ImageLoader()
    
    private let imageCache = NSCache<NSString, UIImage>()

    private init() {}
    
    func loadImage(urlString: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let fileCachePath = FileManager.default.temporaryDirectory
            .appendingPathComponent(url.lastPathComponent, isDirectory: false)
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                completion(.success(cachedImage))
            }
            return
        }
       
        if let data = try? Data(contentsOf: fileCachePath),
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                completion(.success(image))
            }
            imageCache.setObject(image, forKey: urlString as NSString)
            return
        }
        
        downloadData(url: url, toFile: fileCachePath) { error in
            do {
                let data = try Data(contentsOf: fileCachePath)
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    completion(.success(image))
                }
                imageCache.setObject(image, forKey: urlString as NSString)
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
}
