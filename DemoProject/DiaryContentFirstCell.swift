//
//  movieDetailCell.swift
//  DemoProject
//
//  Created by 조경진 on 04/10/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class DiaryContentFirstCell : UITableViewCell {
    
    var yearLabel: UILabel?
    var plotField: UITextView?
    
    var myRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.frame = CGRect(x: 10, y: 15, width: 100, height: 30)
        return label
    }()
    
    var myRatingView: FloatRatingView = {
        let label = FloatRatingView()
        label.frame = CGRect(x: 100, y: 20, width: 100, height: 30)
        label.type = .halfRatings
        label.emptyImage = UIImage(named: "ic_star_large")
        label.fullImage = UIImage(named: "ic_star_large_full")
        label.contentMode = UIView.ContentMode.scaleAspectFit
        
        return label
    }()
    
    var myDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.frame = CGRect(x: 10, y: 40, width: 100, height: 30)
        return label
    }()
   
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(myRatingView)
        self.addSubview(myRatingLabel)
        self.addSubview(myDateLabel)

        self.myRatingView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }

}

extension DiaryContentFirstCell: FloatRatingViewDelegate {

    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        myRatingLabel.text = String(format: "Rate "  + "%.2f" + "점", ratingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        myRatingLabel.text = String(format: "Rate "  + "%.2f" + "점", ratingView.rating)
    }
    
    
}
