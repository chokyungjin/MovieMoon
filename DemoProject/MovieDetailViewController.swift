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
    var movieId: String?
    var movies: [Movie] = []
    var movieDetail: MovieDetail?
    
    var thumbView: UIImageView!
    var heartBtn: UIButton!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    var imageSlideView: ImageSlideshow!
    
    var models = [Model(image: UIImage(named: "img2")! , title: "First image"), Model(image: UIImage(named: "img2")!, title: "Second image"), Model(image: UIImage(named: "img3")!, title: "Third image"), Model(image: UIImage(named: "img4")!, title: "Fourth image")]
    
    let myTable = StickyHeadersLayout()
    
    
    //init..
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addChild(myTable)
        view.addSubview(myTable.tableView)
        fetchMovie()
        
        models[0].image = imageView.image!
        
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
        imageSlideView.setImageInputs(models.map { $0.inputSource })
        imageSlideView.frame = CGRect(origin: .zero, size: CGSize(width: self.view.bounds.width, height: self.view.frame.height / 2.8))
        
        
        view.addSubview(imageSlideView)
        
        thumbView = UIImageView(image: imageView.image)
        thumbView.contentMode = .scaleAspectFit
        thumbView.clipsToBounds = true
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
    override func viewWillAppear(_ animated: Bool) {
        movieId = DataManager.sharedManager.getId()
    }
    
    func fetchMovie() {
        guard let movieId = movieId else { return }
        DataManager.sharedManager.fetchMovieDetail(movieId: movieId, completion: { [weak self] (movie) in
            guard let self = self else { return }
            self.movieDetail = movie
            self.myTable.movieDetail = self.movieDetail
            
            })
        {
            self.showAlertController(title: "요청 실패", message: "알 수 없는 네트워크 에러 입니다.") }
    }
    
    @objc func heartClick(sender: UIButton) {
        
        print(heartBtn.isSelected)
        
        if (heartBtn.isSelected) == false {
            let image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
            heartBtn!.setImage(image, for: .normal)
            heartBtn.isSelected = true
            let Alert = UIAlertController(title: "", message: "heart", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            present(Alert, animated: true, completion: nil)
        }
            
        else if heartBtn.isSelected
        {
            let image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
            heartBtn!.setImage(image, for: .normal)
            heartBtn.isSelected = false
            let Alert = UIAlertController(title: "", message: "cancel", preferredStyle: .alert)
            Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
            present(Alert, animated: true, completion: nil)
        }
    }
    
    @objc func didTap() {
        print(1111)
        let imageSlideView = ImageSlideshow()
        imageSlideView.setImageInputs(models.map { $0.inputSource })
        
        let fullScreenController = imageSlideView.presentFullScreenController(from: self)
        
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
}


extension MovieDetailViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        print("current page:", page)
        
    }
}
