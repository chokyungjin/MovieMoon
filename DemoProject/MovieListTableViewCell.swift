//
//  MovieListTableViewCell.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/30.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ThumnailImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var RatingsLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var GradeImageView: UIImageView!
    @IBOutlet weak var CountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

