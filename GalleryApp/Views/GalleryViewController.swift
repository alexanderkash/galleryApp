//
//  ViewController.swift
//  GalleryApp
//
//  Created by Alexander Kogalovsky on 11/4/21.
//

import UIKit

class GalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var photos = [PhotoInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotoInfo()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        if let layout = collectionView.collectionViewLayout as?
                                    UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    private func getPhotoInfo() {
        NetworkService().fetchPhotosInfo { [weak self] result in
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
        self.show(vc, sender: self)
    }
}

extension GalleryViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier,
                                                      for: indexPath) as! PhotoCell
    
        let url = photos[indexPath.item].url
        let photoUrl = "http://dev.bgsoft.biz/task/\(url).jpg"
        
        let indicator = cell.activityIndicator
        indicator?.hidesWhenStopped = true
        indicator?.startAnimating()
        
        ImageManager.shared.loadImage(urlString: photoUrl) { result in
            switch result {
            case .success(let image):
                cell.imageView.image = image
                indicator?.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        let userName = photos[indexPath.item].userName
        cell.nameLabel.text = userName
        let photoInfoUrl = photos[indexPath.item].photoUrl
        let userUrl = photos[indexPath.item].userUrl
        cell.onAboutPhotoButtonTapped = { self.showDetailInfo(url: photoInfoUrl) }
        cell.onAboutAuthorButtonTapped = { self.showDetailInfo(url: userUrl) }
       
        return cell
    }
}




