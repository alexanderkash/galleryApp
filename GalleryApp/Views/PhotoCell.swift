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
      imageView.cancelImageLoad()
    }
    
    @IBAction private func aboutPhotoButton(_ sender: UIButton) {
        onAboutPhotoButtonTapped?()
    }
    
    @IBAction private func aboutAuthorButton(_ sender: UIButton) {
        onAboutAuthorButtonTapped?()
    }
    
    
}
