//
//  movieDetailCell.swift
//  DemoProject
//
//  Created by 조경진 on 04/10/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class DiaryContentFirstCell : UITableViewCell, UITextFieldDelegate{
    
    var plotField: UITextView?
    let datePickerView:UIDatePicker = UIDatePicker()    //데이트피커로 객체 선언
    static var rating : Double = 0

    
    var RatingLabel: UILabel = {
        let label = UILabel()
        label.text = "Rating"
        label.textColor = .textGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect(x: 10, y: 15, width: 70, height: 30)
        return label
    }()
    
    var myRatingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect(x: 70, y: 15, width: 100, height: 30)
        return label
    }()
    
    var myRatingView: FloatRatingView = {
        let label = FloatRatingView()
        label.frame = CGRect(x: 100, y: 20, width: 150, height: 25)
        label.type = .halfRatings
        label.emptyImage = UIImage(named: "ic_star_large")
        label.fullImage = UIImage(named: "ic_star_large_full")
        label.contentMode = UIView.ContentMode.scaleAspectFit
        label.rating = 0.0
        return label
    }()
    
    var myDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.frame = CGRect(x: 10, y: 50, width: 100, height: 30)
        return label
    }()
   
    var myDateField: UITextField = {
        let label = UITextField()
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
        self.addSubview(RatingLabel)
        
        self.myRatingView.delegate = self
        self.myDateField.delegate = self
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        myDateField.inputView = datePickerView
        
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
        myRatingLabel.text = String(format:"%.2f" + "점", ratingView.rating)
        DiaryContentFirstCell.rating = ratingView.rating

    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        myRatingLabel.text = String(format:"%.2f" + "점", ratingView.rating)
        DiaryContentFirstCell.rating = ratingView.rating
    }
            
}

extension DiaryContentFirstCell {
    
    
    
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        //날짜 바뀌면 쓰는 메소드
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        //현재의 날짜를 보냄 ,year, month , day
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            if month <= 9 && day <= 9{
                myDateField.text = "\(year)-0\(month)-0\(day)"    //앞에 0 붙여서 두자리 수 만들어줌
            }else if month <= 9 && day >= 10{
                myDateField.text = "\(year)-0\(month)-\(day)"     //앞에 0 붙여서 두자리 수 만들어줌
            }else if month >= 10 && day <= 9{
                myDateField.text = "\(year)-\(month)-0\(day)"     //앞에 0 붙여서 두자리 수 만들어줌
            }else if month >= 10 && day >= 10{
                myDateField.text = "\(year)-\(month)-\(day)"
            }
        }
        print(myDateField.text)
        UserDefaults.standard.set(myDateField.text, forKey: "createDate")
    }
    
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
