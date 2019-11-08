//
//  MovieCollectionViewCell.swift
//  DemoProject
//
//  Created by 조경진 on 13/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var imageThumbnail: UIImageView!
    
//    var MovieImage: UIImageView = {
//        let MovieImage = UIImageView()
//        MovieImage.image = #imageLiteral(resourceName: "img_placeholder").withRenderingMode(.alwaysOriginal)
//        return MovieImage
//    }()
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.addSubview(MovieImage)
//        self.backgroundColor = .white
//    }
//
    override func prepareForReuse() {
        
    }
}
