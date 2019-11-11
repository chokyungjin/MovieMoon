//
//  StickyHeaderLayout.swift
//  sticky header
//
//  Created by 조경진 on 26/08/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class StickyHeadersLayout: UITableViewController {

    //vars..
    var imageView: UIImageView? = nil
    var thumbView: UIImageView? = nil
    var heartBtn: UIButton? = nil
    var titleLabel: UILabel? = nil
    var dateLabel: UILabel? = nil
    var black: UIView? = nil
    var floatRatingView: FloatRatingView? = nil
    var movies: [Movie] = []
    let caLayer: CAGradientLayer = CAGradientLayer()

    //inits..
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(movieRatingCell.self, forCellReuseIdentifier: "cell1")
        tableView.register(movieContentCell.self, forCellReuseIdentifier: "cell2")
        tableView.contentInset = UIEdgeInsets(top: view.frame.height / 2.5, left: 0, bottom: 0, right: 0)
            
        tableView.delegate = self
        tableView.dataSource = self
        
//        floatRatingView!.delegate = self
//        floatRatingView!.contentMode = UIView.ContentMode.scaleAspectFit
//        floatRatingView!.type = .halfRatings
        

    }
  
    override func viewWillAppear(_ animated: Bool) {
        createGradient()
    }
   
    //gradient function..
    func createGradient() {
       caLayer.startPoint = CGPoint(x: 0, y: 1)
       caLayer.endPoint = CGPoint(x: 1, y: 1)
       caLayer.colors = [UIColor.clear.cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor]
        imageView!.layer.addSublayer(caLayer)
     }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0,0] {
            return 150
        }
        else if indexPath == [1,0] {
            return 250
        }
        
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath == [0,0]{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! movieRatingCell
           // cell.backgroundColor = .red
           // cell.ratingView.delegate = self as! FloatRatingViewDelegate
           // floatRatingView = cell.ratingView
           // cell.titleLabel.text = String(format: "%.2f" + "점", cell.ratingView.rating)
         //   cell.myRatingLabel.text = "testest"
            
            cell.myRatingLabel.text = "내 기준" + String(format:"%.2f", cell.myRatingView.rating) + "점"
            
            cell.appRatingLabel.text = "앱 기준" + String(describing: DataManager.sharedManager.getRating()) + "점"
            return cell
    

        }
        else if indexPath == [1,0] {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! movieContentCell
            cell.stealcutImage.image = DataManager.sharedManager.getImage()
            cell.plotField.text = "지금까지 이런 맛은 없었다. 이것은 갈비인가 통닭인가, 예 수원 왕갈비 통닭입니다!"

            return cell
        }
        else {
            return UITableViewCell()
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let imageView = imageView, let thumbView = thumbView, let heartBtn = heartBtn , let titleLabel = titleLabel, let dateLabel = dateLabel else{return}
        
        let stretchedHeight = -scrollView.contentOffset.y
        let thumbPosition = stretchedHeight - thumbView.bounds.height - 50
        
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: scrollView.bounds.width, height: stretchedHeight))
        
        thumbView.frame = CGRect(origin: CGPoint(x: 20, y: thumbPosition), size: thumbView.bounds.size)
        
        heartBtn.frame = CGRect(origin: CGPoint(x: scrollView.bounds.width - 60, y: thumbView.frame.origin.y + 130), size: heartBtn.bounds.size)
        
        titleLabel.frame = CGRect(origin: CGPoint(x: scrollView.bounds.width - 250, y: thumbView.frame.origin.y + 70), size: titleLabel.bounds.size)
        titleLabel.text = DataManager.sharedManager.getTitle()
        titleLabel.textColor = .white
        
        dateLabel.frame = CGRect(origin: CGPoint(x: scrollView.bounds.width - 250, y: thumbView.frame.origin.y + 100), size: dateLabel.bounds.size)
        
        dateLabel.text = "개봉일: " + DataManager.sharedManager.getDate()
        dateLabel.textColor = .white
        
        
        caLayer.frame = CGRect(origin: .zero, size: CGSize(width: scrollView.bounds.width, height: stretchedHeight))
        
    }
}

