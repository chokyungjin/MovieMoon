//
//  movieDetailCell.swift
//  DemoProject
//
//  Created by 조경진 on 04/10/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class DiaryContentFirstCell : UITableViewCell{
    
    var yearLabel: UILabel?
    var plotField: UITextView?
    let datePickerView:UIDatePicker = UIDatePicker()    //데이트피커로 객체 선언

    var myRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect(x: 10, y: 15, width: 100, height: 30)
        return label
    }()
    
    var myRatingView: FloatRatingView = {
        let label = FloatRatingView()
        label.frame = CGRect(x: 100, y: 20, width: 150, height: 25)
        label.type = .halfRatings
        label.emptyImage = UIImage(named: "ic_star_large")
        label.fullImage = UIImage(named: "ic_star_large_full")
        label.contentMode = UIView.ContentMode.scaleAspectFit
        
        return label
    }()
    
    var myDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect(x: 10, y: 50, width: 100, height: 30)
        return label
    }()
   
    var myDateField: UILabel = {
        let label = UILabel()
        label.textColor = .textGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect(x: 100, y: 45, width: 150, height: 30)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(myRatingView)
        self.addSubview(myRatingLabel)
        self.addSubview(myDateLabel)
        self.addSubview(myDateField)
        
        self.myRatingView.delegate = self
        
        initGestureRecognizer()

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

extension DiaryContentFirstCell {
    
    
    func initGestureRecognizer() {
        let textFieldTap = UITapGestureRecognizer(target: self, action: #selector(handleTapTextField(_:)))
        textFieldTap.delegate = self
        addGestureRecognizer(textFieldTap)
    }
    
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        print(111)
        self.myDateField.resignFirstResponder()
    }
    
    override func gestureRecognizer(_ gestrueRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: myDateField))! {
            return false
        }
        return true
    }
}
