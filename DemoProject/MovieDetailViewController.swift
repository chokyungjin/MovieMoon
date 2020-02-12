//
//  MovieDetailViewController.swift
//  DemoProject
//
//  Created by 조경진 on 02/10/2019.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import Kingfisher

struct Model {
    var image: UIImage
    let title: String
    
    var inputSource: InputSource {
        return ImageSource(image: image)
    }
}

class MovieDetailViewController: UIViewController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //Vars..
    var movieId: Int?
    var movies: [Movie] = []
    var WishList : WishListModel!
    var movieDetailData: SearchDetailModel!
    var thumbView: UIImageView!
    var heartBtn: UIButton!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var imageSlideView: ImageSlideshow!
    let pageControl = UIPageControl()
    
    var models = [Model(image: UIImage(named: "img2")! , title: "First image"), Model(image: UIImage(named: "img2")!, title: "Second image"), Model(image: UIImage(named: "img3")!, title: "Third image"), Model(image: UIImage(named: "img4")!, title: "Fourth image")]
    
    let myTable = StickyHeadersLayout()
    
    
    //init..
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.addChild(myTable)
        view.addSubview(myTable.tableView)
        SearchService.shared.detailSearch(movieId!) {
            data in
            
            switch data {
            // 매개변수에 어떤 값을 가져올 것인지
            case .success(let data):
                
                // DataClass 에서 받은 유저 정보 반환
                self.movieDetailData = data as! SearchDetailModel
                self.myTable.movieDetailData = self.movieDetailData
                print("!!!!!!!!!!!!!")
                print(self.movieDetailData)
                print("!!!!!!!!!!!!!")
                self.UICall()
                
                
            case .requestErr(let message):
                self.simpleAlert(title: "검색 실패", message: "\(message)")
                
            case .pathErr:
                print(".pathErr")
                
            case .serverErr:
                print(".serverErr")
                
            case .networkFail:
                print("네트워크 오류")
                
            case .dbErr:
                print("디비 에러")
            }
        }
        
        
        
    }
    
    @objc func heartClick(sender: UIButton) {
        
        if (heartBtn.isSelected) == false {
            let image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
            heartBtn!.setImage(image, for: .normal)
            heartBtn.isSelected = true
            
            //self.movieDetailData.id
            //유저 디폴트로 접근
            //여기서 위시리스트 등록하는 통신 시작
            print(self.movieDetailData.id, UserDefaults.standard.integer(forKey: "Id"))
            
            WishListService.shared.postWishList(self.movieDetailData.id , UserDefaults.standard.integer(forKey: "Id")) {
                data in
                
                switch data {
                // 매개변수에 어떤 값을 가져올 것인지
                case .success(let data):
                    
                    // DataClass 에서 받은 유저 정보 반환
                    self.WishList = data as! WishListModel
                    print(self.WishList)
                    let Alert = UIAlertController(title: "", message: "위시리스트에 추가합니다", preferredStyle: .alert)
                    Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(Alert, animated: true, completion: nil)
                    
                case .requestErr(let message):
                    self.simpleAlert(title: "등록된 위시리스트 였네요!", message: "갱신합니다")
                    let image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
                    self.heartBtn!.setImage(image, for: .normal)
                    self.heartBtn.isSelected = true
                    
                case .pathErr:
                    print(".pathErr")
                    
                case .serverErr:
                    print(".serverErr")
                    
                case .networkFail:
                    print("네트워크 오류")
                    
                case .dbErr:
                    print("디비 에러")
                }
            }
            
            
            
        }
            
        else if heartBtn.isSelected
        {
            let image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
            heartBtn!.setImage(image, for: .normal)
            heartBtn.isSelected = false
            
            //여기서 위시리스트 삭제하는 통신 시작
            WishListService.shared.deleteWishList(self.movieDetailData.id , UserDefaults.standard.integer(forKey: "Id")) {
                data in
                
                switch data {
                // 매개변수에 어떤 값을 가져올 것인지
                case .success(let data):
                    
                    // DataClass 에서 받은 유저 정보 반환
//                    self.WishList = data as! WishListModel
//                    print(self.WishList)
                    
                    let Alert = UIAlertController(title: "", message: "위시리스트에서 삭제합니다", preferredStyle: .alert)
                    Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                    self.present(Alert, animated: true, completion: nil)
                    
                case .requestErr(let message):
                    self.simpleAlert(title: "없는 위시리스트 였네요!", message: "갱신합니다")
                    let image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
                    self.heartBtn!.setImage(image, for: .normal)
                    self.heartBtn.isSelected = false
                    
                case .pathErr:
                    print(".pathErr")
                    
                case .serverErr:
                    print(".serverErr")
                    
                case .networkFail:
                    print("네트워크 오류")
                    
                case .dbErr:
                    print("디비 에러")
                }
            }
            
        }
        
        print(heartBtn.isSelected)
        
    }
    
    @objc func didTap() {
        print(1111)
        let imageSlideView = ImageSlideshow()
        imageSlideView.setImageInputs(models.map { $0.inputSource })
        
        let fullScreenController = imageSlideView.presentFullScreenController(from: self)
        
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    func UICall() {
        let thumnailImage = UIImageView()
        thumnailImage.imageFromUrl(movieDetailData?.poster , defaultImgPath: "img_placeholder")
        self.imageView = thumnailImage
        self.models[0].image = self.imageView.image!
        
        let imageSlideView = ImageSlideshow()
        imageSlideView.slideshowInterval = 0
        imageSlideView.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideView.contentScaleMode = UIViewContentMode.scaleToFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        imageSlideView.pageIndicator = pageControl
        
        imageSlideView.activityIndicator = DefaultActivityIndicator()
        imageSlideView.delegate = self
        imageSlideView.setImageInputs(self.models.map { $0.inputSource })
        imageSlideView.frame = CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width, height: self.view.frame.height / 3))
        
        view.addSubview(imageSlideView)
        
        //여기서 imageView가 nil이다
        
        thumbView = UIImageView(image: imageView.image)
        thumbView.contentMode = .scaleAspectFit
        thumbView.clipsToBounds = false
        view.addSubview(thumbView)
        
        heartBtn = UIButton(type: .custom)
        let image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        heartBtn.setImage(image, for: .normal)
        heartBtn.tintColor = .white
        heartBtn.contentMode = .scaleAspectFit
        heartBtn.bounds.size = CGSize(width: 30, height: 30)
        heartBtn.isSelected = false
        heartBtn.addTarget(self, action: #selector(heartClick), for: .touchUpInside)
        view.addSubview(heartBtn)
        
        titleLabel = UILabel()
        titleLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(dateLabel)
        
        myTable.imageSlideView = imageSlideView
        myTable.thumbView = thumbView
        myTable.heartBtn = heartBtn
        myTable.titleLabel = titleLabel
        myTable.dateLabel = dateLabel
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(MovieDetailViewController.didTap))
        imageSlideView.addGestureRecognizer(recognizer)
        
    }
    
}


extension MovieDetailViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        
    }
}
