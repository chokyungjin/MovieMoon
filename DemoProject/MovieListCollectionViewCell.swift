//
//  MovieListCollectionViewCell.swift
//  DemoProject
//
//  Created by 조경진 on 07/10/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumnailimageView: UIImageView!
     @IBOutlet weak var titlelabel: UILabel!
     @IBOutlet weak var ratingslabel: UILabel!
     @IBOutlet weak var datelabel: UILabel!
     @IBOutlet weak var gradeimageView: UIImageView!
    
    override func prepareForReuse() {
        //thumnailImageView.image = UIImage(named: "img_placeholder")
    }
}
