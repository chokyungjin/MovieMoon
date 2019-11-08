//
//  MovieListTableViewCell.swift
//  boxoffice
//
//  Created by Cho on 17/12/2018.
//  Copyright © 2018 Cho. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var ThumnailImageView : UIImageView!
    @IBOutlet weak var TitleLabelL :UILabel!
    @IBOutlet weak var RatingsLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var GradeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
