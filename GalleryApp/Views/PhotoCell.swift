//
//  PhotoCell.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/4/21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let identifier = "photoCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var onAboutPhotoButtonTapped: (() -> Void)?
    var onAboutAuthorButtonTapped: (() -> Void)?
    
    override func prepareForReuse() {
      imageView.image = nil
    }
    
    func configure(photos: [PhotoInfo], indexPath: IndexPath) {
        let url = photos[indexPath.item].url
        let photoUrl = "http://dev.bgsoft.biz/task/\(url).jpg"
        let userName = photos[indexPath.item].userName
        nameLabel.text = userName
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        ImageLoader.shared.loadImage(urlString: photoUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction private func aboutPhotoButtonPressed(_ sender: UIButton) {
        onAboutPhotoButtonTapped?()
    }
    
    @IBAction private func aboutAuthorButtonPressed(_ sender: UIButton) {
        onAboutAuthorButtonTapped?()
    }
}
