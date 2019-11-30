//
//  MovieListTableViewCell.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/30.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

