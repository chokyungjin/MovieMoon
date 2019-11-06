//
//  SettingMenuTableViewCell.swift
//  DemoProject
//
//  Created by 조경진 on 13/09/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class SettingMenuTableViewCell: UITableViewCell {

    //IBOutlet
    @IBOutlet weak var menuLabel: UILabel!
    
    //init
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
