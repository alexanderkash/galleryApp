//
//  ViewController.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/4/21.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let cellScaleRate: CGFloat = 0.88
    private let photoInfoLoader = PhotoInfoLoader()
    private var photos = [Photo]()
    private var animator: LinearCardAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotosInfo()
        configureCollectionView()
        animator = LinearCardAnimator(scaleRate: cellScaleRate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.hidesBarsOnSwipe = false
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.horizontalScrollIndicatorInsets.bottom = 1
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        layout.itemSize = UIScreen.main.bounds.size
        collectionView.collectionViewLayout = layout
    }
    
    private func getPhotosInfo() {
        photoInfoLoader.loadPhotosInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.photos = photos.sorted {
                    $0.userName.lowercased() < $1.userName.lowercased()
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func showDetailInfo(url: String) {
        guard let vc = storyboard?.instantiateViewController(
                identifier: "DetailInfoViewController",
                creator: { coder in
                    DetailInfoViewController(url: url, coder: coder)
                })
        else { fatalError("Failed to create Detail Info VC") }
        show(vc, sender: self)
    }
}

extension GalleryViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier,
                                                      for: indexPath) as! PhotoCell
        
        cell.transform = CGAffineTransform(scaleX: cellScaleRate, y: cellScaleRate)
        cell.configure(photos: photos, indexPath: indexPath)
        
        let photoInfoUrl = photos[indexPath.item].photoUrl
        let userUrl = photos[indexPath.item].userUrl
        
        cell.onAboutPhotoButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.showDetailInfo(url: photoInfoUrl)
        }
        cell.onAboutAuthorButtonTapped = { [weak self] in
            guard let self = self else { return }
            self.showDetailInfo(url: userUrl) }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCell else { return }
        let url = photos[indexPath.item].url
        let photoUrlString = String(format: cell.photoUrl, url)
        let canceledTaskUrl = URL(string: photoUrlString)
        cell.cancelDownloadImage(url: canceledTaskUrl)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        for cell in collectionView.visibleCells as! [PhotoCell] {
            animator?.animate(cell: cell, collectionView: collectionView, layout: layout)
            guard let imageView = cell.imageView else { return }
            animator?.addParallaxEffect(cell: cell,
                                       imageView: imageView,
                                       collectionView: collectionView,
                                       layout: layout)
        }
    }
}








