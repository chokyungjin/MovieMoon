//
//  MovieDiarySearchViewCell.swift
//  DemoProject
//
//  Created by 조경진 on 2020/02/12.
//  Copyright © 2020 조경진. All rights reserved.
//

import UIKit

class MovieDiarySearchViewCell: UITableViewCell {

    @IBOutlet weak var ThumnailImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var NationLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var CountLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

