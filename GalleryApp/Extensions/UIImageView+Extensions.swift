//
//  UIImageView+Extensions.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/4/21.
//

import UIKit

extension UIImageView {
    
    func loadImage(at url: URL, completion: (() -> Void)?) {
        UIImageLoader.loader.load(url, for: self) {
            completion?()
        }
  }

  func cancelImageLoad() {
    UIImageLoader.loader.cancel(for: self)
  }

}

extension UIImageView {
    
    func loadImages(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        let cache = URLCache.shared
        let request = URLRequest(url: imageURL)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data,
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.transitionToImage(toImage: image)
                }
            } else {
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data, let response = response, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.transitionToImage(toImage: image)
                        }
                    }
                }.resume()
            }
        }
    }
    
    func transitionToImage(toImage image: UIImage?) {
        UIView.transition(with: self,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {self.image = image},
                          completion: nil)
    }
}


