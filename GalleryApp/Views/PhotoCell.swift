//
//  PhotoCell.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/4/21.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let identifier = "photoCell"
    
    let photoUrl = "http://dev.bgsoft.biz/task/%@.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var aboutPhotoButton: UIButton!
    @IBOutlet weak var aboutAuthorButton: UIButton!
    
    var onAboutPhotoButtonTapped: (() -> Void)?
    var onAboutAuthorButtonTapped: (() -> Void)?
    
    override func prepareForReuse() {
      imageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 30
        containerView.clipsToBounds = true
        addShadow()
    }
    
    func configure(photos: [Photo], indexPath: IndexPath) {
        hidePhotoInfo()
        let url = photos[indexPath.item].url
        let photoUrl = String(format: self.photoUrl, url)
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
                self.showPhotoInfo()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func addShadow() {
        layer.shadowRadius = 5
        layer.shadowOffset.height = 4
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        self.clipsToBounds = false
    }
    
    private func hidePhotoInfo() {
        nameLabel.isHidden = true
        aboutPhotoButton.isHidden = true
        aboutAuthorButton.isHidden = true
    }
    
    private func showPhotoInfo() {
        nameLabel.isHidden = false
        aboutPhotoButton.isHidden = false
        aboutAuthorButton.isHidden = false
    }
    
    @IBAction private func aboutPhotoButtonTapped(_ sender: UIButton) {
        onAboutPhotoButtonTapped?()
    }
    
    @IBAction private func aboutAuthorButtonTapped(_ sender: UIButton) {
        onAboutAuthorButtonTapped?()
    }
}

