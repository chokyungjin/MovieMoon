//
//  StickyHeaderLayout.swift
//  sticky header
//
//  Created by 조경진 on 26/08/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit
import ImageSlideshow

class StickyHeadersLayout: UITableViewController {
    
    //vars..
    //영화 상세정보
    var movieDetailData: SearchDetailModel? = nil
    var imageSlideView: ImageSlideshow? = nil
    var thumbView: UIImageView? = nil
    var heartBtn: UIButton? = nil
    var titleLabel: UILabel? = nil
    var dateLabel: UILabel? = nil
    let caLayer: CAGradientLayer = CAGradientLayer()
    let dateFormatter = DateFormatter()
    let realdateFormatter = DateFormatter()
    
    
    //inits..
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(movieRatingCell.self, forCellReuseIdentifier: "cell1")
        tableView.register(movieContentCell.self, forCellReuseIdentifier: "cell2")
        tableView.contentInset = UIEdgeInsets(top: view.frame.height / 3, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .blackgroundBlack
        dateFormatter.locale = Locale.init(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyyMMdd"
        realdateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        thumbView?.frame = CGRect(origin: CGPoint(x: 20, y: 76), size: CGSize(width: 99.0, height: 141.0))
        self.heartBtn?.frame = CGRect(origin: CGPoint(x: 315.0, y: 194.5), size: CGSize(width: 30.0, height: 30.0))
        self.titleLabel?.frame = CGRect(origin: CGPoint(x: 125, y: 144.5), size: CGSize(width: 200.0, height: 30.0))
        self.dateLabel?.frame = CGRect(origin: CGPoint(x: 125, y: 174.5), size: CGSize(width: 200.0, height: 30.0))
        //        createGradient()
        tableView.reloadData()
        
    }
    
    func createGradient() {
        // print(111)
        caLayer.startPoint = CGPoint(x: 0.5, y: 0)
        caLayer.endPoint = CGPoint(x: 0.5, y: 1)
        caLayer.locations = [0,1]
        caLayer.frame = imageSlideView!.frame
        caLayer.colors = [UIColor.clear.cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor]
        imageSlideView!.layer.addSublayer(caLayer)
    }
    
    
    
    //override...
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
            return 1000
        }
        
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == [0,0]{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! movieRatingCell
            
            if movieDetailData?.id != nil {
                cell.appRatingLabel.text = "무비 문 기준 " + String(describing: (4.5))  + "점"
                DataManager.sharedManager.setRating(haveRating: Double(4.5))
            }
            cell.backgroundColor = .blackgroundBlack
            cell.myRatingLabel.text = "내 기준 " + String(format:"%.2f", cell.myRatingView.rating) + "점"
            cell.myRatingLabel.textColor = .textGray
            cell.appRatingLabel.textColor = .textGray
            cell.selectionStyle = .none
            
            return cell
            
            
        }
        else if indexPath == [1,0] {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! movieContentCell
            
            cell.backgroundColor = .blackgroundBlack
            cell.stillcutImage.imageFromUrl(movieDetailData?.poster , defaultImgPath: "img_placeholder")
            
            if movieDetailData?.director != nil && movieDetailData?.actor != nil {
                cell.peopleField.text = String(describing: "감독 및 배우들 \n  " + (movieDetailData!.director! + movieDetailData!.actor!) )
            }
            if movieDetailData?.plot != nil {
                cell.plotField.text = String(describing: "줄거리 \n " + (movieDetailData!.plot!))
            }
            
            cell.peopleField.backgroundColor = .blackgroundBlack
            cell.peopleField.textColor = .textGray
            cell.peopleField.isUserInteractionEnabled = false
            
            cell.plotField.backgroundColor = .blackgroundBlack
            cell.plotField.textColor = .textGray
            cell.plotField.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let imageView = imageSlideView, let thumbView = thumbView, let heartBtn = heartBtn , let titleLabel = titleLabel, let dateLabel = dateLabel else{return}
        
        let stretchedHeight = -scrollView.contentOffset.y + 10
        let thumbPosition = stretchedHeight - thumbView.bounds.height - 50
        
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: scrollView.bounds.width, height: stretchedHeight))
        thumbView.frame = CGRect(origin: CGPoint(x: 20, y: thumbPosition), size: CGSize(width: 99.0, height: 141.0))
        heartBtn.frame = CGRect(origin: CGPoint(x: scrollView.bounds.width - 60, y: thumbView.frame.origin.y + 120), size: heartBtn.bounds.size)
        titleLabel.frame = CGRect(origin: CGPoint(x: scrollView.bounds.width - 250, y: thumbView.frame.origin.y + 70), size: titleLabel.bounds.size)
        titleLabel.text = movieDetailData?.korTitle
        titleLabel.textColor = .textGray
        
        dateLabel.frame = CGRect(origin: CGPoint(x: scrollView.bounds.width - 250, y: thumbView.frame.origin.y + 100), size: dateLabel.bounds.size)
        
        if movieDetailData?.releaseDate! != "" {
            
            let date = dateFormatter.date(from: (movieDetailData?.releaseDate!)!)
            let releaseDate = realdateFormatter.string(from: date!)
            dateLabel.text = "개봉일 : " + releaseDate
            dateLabel.textColor = .textGray
            
        }
        else {
            dateLabel.text = "개봉일 정보가 없습니다"
        }
        
        caLayer.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: stretchedHeight))
        
    }
}


extension UIViewController {
    func showAlertController(title: String, message: String) {
        let style = UIAlertController.Style.alert
        
        let alertController: UIAlertController = UIAlertController(title: "요청 실패", message: "알수없는 네트워크 에러 입니다.", preferredStyle: style)
        
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction) in
            print("OK preseed \(action.title ?? "")")
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

