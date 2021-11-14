//
//  LinearCardAnimator.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/14/21.
//

import UIKit

struct LinearCardAnimator {
    
    let scaleRate: CGFloat
    let minAlpha: CGFloat
    let parallaxSpeed: CGFloat
    
    init(scaleRate: CGFloat = 0.9, minAlpha: CGFloat = 0.4, parallaxSpeed: CGFloat = 0.5) {
        self.scaleRate = scaleRate
        self.minAlpha = minAlpha
        self.parallaxSpeed = parallaxSpeed
    }
    
    func animate(cell: UICollectionViewCell,
                 collectionView: UICollectionView,
                 layout: UICollectionViewFlowLayout) {
        
        let distance: CGFloat
        let itemOffset: CGFloat
        if layout.scrollDirection == .horizontal {
            distance = collectionView.frame.width
            itemOffset = cell.center.x - collectionView.contentOffset.x
        } else {
            distance = collectionView.frame.height
            itemOffset = cell.center.y - collectionView.contentOffset.y
        }
        let position = itemOffset / distance - 0.5
        let scaleFactor = scaleRate - 0.1 * abs(position)
        cell.alpha = 1.0 - abs(position) + minAlpha
        cell.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
    }
    
    func addParallaxEffect(cell: UICollectionViewCell,
                           imageView: UIImageView,
                           collectionView: UICollectionView,
                           layout: UICollectionViewFlowLayout) {
        
        let offsetX = collectionView.contentOffset.x
        let offsetY = collectionView.contentOffset.y
        let width = imageView.bounds.width
        let height = imageView.bounds.height
        let x: CGFloat
        let y: CGFloat
        if layout.scrollDirection == .horizontal {
            y = imageView.frame.origin.y
            x = ((offsetX - cell.frame.origin.x) / width) * (parallaxSpeed * 100)
        } else {
            x = imageView.frame.origin.x
            y = ((offsetY - cell.frame.origin.y) / height) * (parallaxSpeed * 100)
        }
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
    }
}
