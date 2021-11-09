//
//  UIImageLoader.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/4/21.
//

import Foundation

import UIKit

class UIImageLoader {
    
    static let loader = UIImageLoader()
    
    private let imageLoader = ImageLoader()
    private var uuidMap = [UIImageView: UUID]()
    
    private init() {}
        
    func load(_ url: URL, for imageView: UIImageView, completion: (() -> Void)?) {
        let token = imageLoader.loadImage(url) { result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    imageView.image = image
                    completion?()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        if let token = token {
            uuidMap[imageView] = token
        }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}
