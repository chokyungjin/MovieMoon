//
//  DiaryDetailViewController.swift
//  DemoProject
//
//  Created by 조경진 on 2019/11/16.
//  Copyright © 2019 조경진. All rights reserved.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    
    //Vars..
    var movieId: Int?
    var diaryId : Int?
    var movies: [Movie] = []
    var movieDetail: MovieDetail?
    var movieDetailData: SearchDetailModel!
    var movieSearchResultData: SearchTitleModel!
    var thumbView: UIImageView!
    var heartBtn: UIButton!
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var dateLabel: UILabel!
    let myTable = DiaryStickHeaderLayout()
    
    //init..
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UICall()
        print("%%%%%%%%%%%%%%%%")
        print(movieSearchResultData)
        print("%%%%%%%%%%%%%%%%")
        
        // imageView.imageFromUrl("http://file.koreafilm.or.kr/thm/02/00/01/05/tn_DPK002911.jpg"   , defaultImgPath: "img_placeholder")
        
        //Diary Detail 통신 해야됨.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.addChild(myTable)
        view.addSubview(myTable.tableView)
        
        
        UICall()
        
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        view.addSubview(imageView)
        
        
        thumbView.image = UIImage(named: "img_placeholder")
        //        thumbView = UIImageView(image: imageView.image)
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
        heartBtn.tintColor = UIColor.clear
        //view.addSubview(heartBtn)
        
        titleLabel = UILabel()
        titleLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(dateLabel)
        
        myTable.imageView = imageView
        myTable.thumbView = thumbView
        myTable.titleLabel = titleLabel
        myTable.dateLabel = dateLabel
    }
    
    func UICall() {
        
        self.imageView.setImage(#imageLiteral(resourceName: "AppleLogo"))
        //  self.imageView.image = UIImage(named: "img_placeholder")
        
        // imageView.imageFromUrl("http://file.koreafilm.or.kr/thm/02/00/01/05/tn_DPK002911.jpg"   , defaultImgPath: "img_placeholder")
        
        //        imageView.imageFromUrl(movieSearchResultData.poster!, defaultImgPath: "img_placeholder")
        
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: view.bounds.height / 4))
        
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        view.addSubview(imageView)
        
        
        thumbView.image = UIImage(named: "img_placeholder")
        //thumbView = UIImageView(image: imageView.image)
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
        heartBtn.tintColor = UIColor.clear
        //view.addSubview(heartBtn)
        
        titleLabel = UILabel()
        titleLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(titleLabel)
        
        dateLabel = UILabel()
        dateLabel.bounds.size = CGSize(width: 200, height: 30)
        view.addSubview(dateLabel)
        
        
        
        
    }
    
}


