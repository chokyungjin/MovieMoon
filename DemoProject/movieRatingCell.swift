//
//  movieDetailCell.swift
//  DemoProject
//
//  Created by 조경진 on 04/10/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class movieRatingCell : UITableViewCell {
    
    //앱이 준 별점 , 내가 준 별점.
    
    
    var yearLabel: UILabel?
    var plotField: UITextView?
    
    var myRatingView: FloatRatingView = {
        let label = FloatRatingView()
        label.frame = CGRect(x: 10, y: 0, width: 150, height: 30)
        label.type = .halfRatings
        label.emptyImage = UIImage(named: "ic_star_large")
        label.fullImage = UIImage(named: "ic_star_large_full")
        //label.backgroundColor = .red
        label.contentMode = UIView.ContentMode.scaleAspectFit
        
        return label
    }()
    var myRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.frame = CGRect(x: 10, y: 40, width: 150, height: 20)
        return label
    }()
    var appRatingView: FloatRatingView = {
        let label = FloatRatingView()
        label.frame = CGRect(x: 10, y: 65, width: 150, height: 30)
        label.type = .floatRatings
        label.emptyImage = UIImage(named: "ic_star_large")
        label.fullImage = UIImage(named: "ic_star_large_full")
        //label.backgroundColor = .red
        label.contentMode = UIView.ContentMode.scaleAspectFit
        label.rating = (DataManager.sharedManager.getRating()) / 2
        label.isUserInteractionEnabled = false

        return label
    }()
    
    var appRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.frame = CGRect(x: 10, y: 95, width: 150, height: 20)
        return label
    }()
   
  
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(myRatingView)
        self.addSubview(myRatingLabel)
        
        self.addSubview(appRatingLabel)
        self.addSubview(appRatingView)

        self.myRatingView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }

}

extension movieRatingCell: FloatRatingViewDelegate {

    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        myRatingLabel.text = String(format: "내 기준 "  + "%.2f" + "점", ratingView.rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        myRatingLabel.text = String(format: "내 기준 "  + "%.2f" + "점", ratingView.rating)
    }
    
}
