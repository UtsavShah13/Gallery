//
//  HomeViewController.swift
//  GalleryApplication
//
//  Created by Utsav Shah on 31/03/24.
//

import UIKit

class GalleryViewController: UIViewController {
    
    private lazy var viewModel = GalleryViewModel (
            delegate: self
    )
    
    var galleryList : [Hits]?
    var currentPage: Int = 1
    var totalDataCountFetchPrevious = 0
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        setupCollectionView()
        viewModel.performApiCallingForGallery(page: "\(currentPage)")
        previewView.isHidden = true
    }
        
    func setupCollectionView() {
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        galleryCollectionView.register(cell: Cell.galleryCollectionViewCell)
        galleryCollectionView.showsVerticalScrollIndicator = false
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        galleryCollectionView!.collectionViewLayout = layout
    }
    
    func moveToProfileScreen() {
        let storyBoard = UIStoryboard(name: StoryBoard.main, bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: Controller.profileVC) as? ProfileViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

//    MARK: - Button Actions
    
    @IBAction func hidePreviewAction(_ sender: UIButton) {
        previewView.isHidden = true
    }
    
    @IBAction func profileAction(_ sender: UIButton) {
        moveToProfileScreen()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.galleryCollectionViewCell, for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell() }
        cell.fillCell(imagePath: galleryList?[indexPath.item].previewURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if ((galleryList?.count ?? 0) - 2) == indexPath.item {
            if totalDataCountFetchPrevious < galleryList?.count ?? 0 {
                currentPage = currentPage + 1
                totalDataCountFetchPrevious = galleryList?.count ?? 0
                viewModel.performApiCallingForGallery(page: "\(currentPage)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInCol = 3   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInCol - 1))
        let width = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInCol))
        return CGSize(width: width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let path = URL(string: galleryList?[indexPath.item].largeImageURL ?? "")
        previewImageView.sd_setImage(with: path)
        previewView.isHidden = false
    }
        
}

// MARK: - GalleryViewModelDelegate

extension GalleryViewController: GalleryViewModelDelegate {
    
    func handleGalleryResponse(responce: galleryData) {
        if responce.hits?.count ?? 0 > 0 {
            if galleryList?.count == 0 || galleryList == nil {
                galleryList = responce.hits
            } else {
                galleryList?.append(contentsOf: responce.hits!)
            }
        }
        galleryCollectionView.reloadData()
    }

}
