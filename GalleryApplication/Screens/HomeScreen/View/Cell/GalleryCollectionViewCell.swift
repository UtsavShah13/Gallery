//
//  GalleryCollectionViewCell.swift
//  GalleryApplication
//
//  Created by Utsav Shah on 31/03/24.
//

import UIKit
import SDWebImage

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillCell(imagePath: String?) {
        let path = URL(string: imagePath ?? "")
        imageView.sd_setImage(with: path)
    }

}
