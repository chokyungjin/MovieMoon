//
//  DiaryContentSecond.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/17.
//  Copyright © 2019 조경진. All rights reserved.
//

import Foundation

class DiaryContentSecondCell : UITableViewCell {
    
    
    var plotField: UITextView = {
        let label = UITextView()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.frame = CGRect(x: 15, y: 15, width: 350, height: 100)
        return label
    }()
    var stillcutImage: UIImageView = {
        let ImageView = UIImageView()
        let defaultImage = UIImage(named: "testImage.jpg")
        ImageView.image = defaultImage
        ImageView.frame = CGRect(x: 20, y: 120, width: 100, height: 150)
       
        return ImageView
    }()
    var stillcutImage2: UIImageView = {
        let ImageView = UIImageView()
        let defaultImage = UIImage(named: "testImage.jpg")
        ImageView.image = defaultImage
        ImageView.frame = CGRect(x: 140, y: 120, width: 100, height: 150)
       
        return ImageView
    }()
    var stillcutImage3: UIImageView = {
        let ImageView = UIImageView()
        let defaultImage = UIImage(named: "testImage.jpg")
        ImageView.image = defaultImage
        ImageView.frame = CGRect(x: 260, y: 120, width: 100, height: 150)
       
        return ImageView
    }()
   
  
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(plotField)
        self.addSubview(stillcutImage)
        self.addSubview(stillcutImage2)
        self.addSubview(stillcutImage3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }

}
